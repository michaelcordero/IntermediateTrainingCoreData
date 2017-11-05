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
    
    //Model Objects
    var companies: [Company]?

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
