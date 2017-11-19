//
//  CompaniesViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/4/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit
import CoreData

class CompaniesViewController: UITableViewController {
    
    // MARK: - Properties
    var companies = [Company]()
    
    // MARK: - ViewController Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.companies = CoreDataManager.shared.fetchCompanies()
        // Create Buttons
        navigationItem.leftBarButtonItems = [UIBarButtonItem.init(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
                                             UIBarButtonItem.init(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))]
        // Create Navigation Controller UI
        view.backgroundColor = UIColor.white
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        tableView.backgroundColor = UIColor.navy
        //tableView.separatorStyle = .none       //makes line seperators go away within table
        tableView.tableFooterView = UIView()    //makes line separators go away within background
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorColor = .white
    }
    
    // MARK: - Controller Functions
    
    @objc private func handleAddCompany() {
        let createVC = CreateCompanyViewController()
        let navController = UINavigationController(rootViewController: createVC)
        createVC.delegate = self
        present(navController, animated: true, completion: nil)
        print("Adding company..")
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        CoreDataManager.shared.reset()
        var indexPathsToRemove = [IndexPath]()
        // the following lines allow the animation to happen
        for (index, _ ) in companies.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsToRemove.append(indexPath)
        }
        companies.removeAll()
        tableView.deleteRows(at: indexPathsToRemove, with: .fade)
        tableView.reloadData()
    }
    
    @objc private func doWork() {
        print("Trying to do work...")
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save: ", err)
            }
        })
    }
    
    @objc private func doUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                 let companies = try backgroundContext.fetch(request)
                companies.forEach({ print( $0.name ?? ""); $0.name = "C: \($0.name ?? "")"})
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        // reset will forget all the objects you've fetched before!
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        //is there a way to merge the changes that you just made onto the view context?
                        self.tableView.reloadData()
                    }
                } catch let saveError {
                    print("Failed to save on background: ", saveError)
                }
            } catch let fetchError {
                print("Failed to fetch companies: ", fetchError)
            }
            
        }
    }
  
}
