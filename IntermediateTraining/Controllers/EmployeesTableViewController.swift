//
//  EmployeesTableViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/13/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var company: Company?

    // MARK: - Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.navy
        setupPlusButtonInNavBar(selector: #selector(handleAdd))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Functions
    @objc private func handleAdd() {
        print("Trying to add an employee..")
        let createEVC = CreateEmployeeViewController()
        let navVC = UINavigationController(rootViewController: createEVC)
        present(navVC, animated: true, completion: nil)
    }

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
