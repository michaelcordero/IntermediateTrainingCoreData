//
//  CompaniesViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/4/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit
import CoreData

class CompaniesViewController: UITableViewController, CreateCompanyControllerDelegate {
    
    // MARK - Properties
    var companies: [Company]?
    
    // MARK - ViewController Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TEST ADD", style: .plain, target: self, action: #selector(addCompany))
        view.backgroundColor = UIColor.white
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        tableView.backgroundColor = UIColor.navy
        //tableView.separatorStyle = .none       //makes line seperators go away within table
        tableView.tableFooterView = UIView()    //makes line separators go away within background
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorColor = .white
        fetchCompanies()
    }
    
    // MARK - Table Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Object References
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let company: Company = companies![indexPath.row]

        // Table cell settings
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let company = self.companies![indexPath.row]
            print("Attempting to delete company: ", company.name ?? "")
            
            // remove company from tableView
            self.companies?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // delete company from CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company) // deletes from memory context
            do {
                try context.save() // actually persists the deletion
            } catch let saveError {
                print("Failed to delete company: ", saveError)
            }
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            print("Editing company ..")
        }
        return [deleteAction, editAction]
    }
    
    // MARK - Controller Functions
    
    @objc func handleAddCompany() {
        let createVC = CreateCompanyViewController()
        let navController = CustomNavigationController(rootViewController: createVC)
        createVC.delegate = self
        present(navController, animated: true, completion: nil)
        print("Adding company..")
    }
    
    func didAddCompany(company: Company) {
        companies?.append(company)
        let newIndexPath = IndexPath(row: (companies?.count)! - 1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func fetchCompanies() {
        //preparing container
        let container = NSPersistentContainer(name: "IntermediateTraining")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, err) in if let err = err {
            fatalError("Loading of store failed: \(err)")
            }})
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        //fetch companies
        do{
            let companies = try context.fetch(fetchRequest)
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchErr{
            print("Failed to fetch companiess: ", fetchErr)
        }
    }
  
}
