//
//  EmployeesTableViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/13/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit
import CoreData

class EmployeesTableViewController: UITableViewController, CreateEmployeeControllerDelegate {
    
    // MARK: - Properties
    var company: Company?
    var employees: [Employee] = [Employee]()
    let cellID: String = "employee_cell"

    // MARK: - Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.backgroundColor = UIColor.navy
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
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
        createEVC.delegate = self
        let navVC = UINavigationController(rootViewController: createEVC)
        present(navVC, animated: true, completion: nil)
    }
    
    private func fetchEmployees() {
        print("Trying to fetch employees...")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(request)
            self.employees = employees
            //employees.forEach({print("Employee name: ", $0.name ?? "")})
        } catch let fetchError {
            print("Failed to fetch employees: ", fetchError)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    // MARK: - Protocol
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }

}
