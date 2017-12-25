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
        navigationItem.title = "Companies"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "database-delete"), style: .plain, target: self, action: #selector(handleReset))
        // Create Navigation Controller UI
        view.backgroundColor = UIColor.white
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        tableView.backgroundColor = UIColor.navy
        //tableView.separatorStyle = .none       //makes line seperators go away within table
        tableView.tableFooterView = UIView()    //makes line separators go away within background
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorColor = .white
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        self.refreshControl = refreshControl
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
    
    @objc private func handleRefresh() {
        Service.shared.downloadCompanies()
        self.companies = CoreDataManager.shared.fetchCompanies()
        self.refreshControl?.endRefreshing() //makes drag-down gesture end
        self.tableView.reloadData()
        viewDidLoad()
    }
    
    @objc private func doWork() {
//        print("Trying to do work...")
//        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
//            (0...5).forEach { (value) in
//                print(value)
//                let company = Company(context: backgroundContext)
//                company.name = String(value)
//            }
//            do {
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    self.companies = CoreDataManager.shared.fetchCompanies()
//                    self.tableView.reloadData()
//                }
//            } catch let err {
//                print("Failed to save: ", err)
//            }
//        })
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
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now...")
        DispatchQueue.global(qos: .background).async {
            // creating background thread
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            // accessing main thread
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            // execute updates on background thread
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                do {
                    try privateContext.save()
                    // after save succeeds
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                               try context.save()
                            }
                            self.tableView.reloadData()
                        } catch let finalSaveErr {
                            print("Failed to save main context: ", finalSaveErr)
                        }
                        
                        
                    }
                } catch let saveErr {
                    print("Failed to save on private context: ", saveErr)
                }
                
            } catch let fetchErr {
                print("Failed to fetch on private context: ", fetchErr)
            }
        }
    }
  
}
