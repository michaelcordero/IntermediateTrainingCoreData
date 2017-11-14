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
        // Create Reset Button
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        // Create Navigation Controller UI
        view.backgroundColor = UIColor.white
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        tableView.backgroundColor = UIColor.navy
        //tableView.separatorStyle = .none       //makes line seperators go away within table
        tableView.tableFooterView = UIView()    //makes line separators go away within background
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorColor = .white
    }
    
    // MARK: - Controller Functions
    
    @objc private func handleAddCompany() {
        let createVC = CreateCompanyViewController()
        let navController = CustomNavigationController(rootViewController: createVC)
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
  
}
