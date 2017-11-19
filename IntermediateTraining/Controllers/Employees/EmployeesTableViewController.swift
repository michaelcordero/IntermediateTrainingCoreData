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
    let cellID: String = "employee_cell"
    var executives = [Employee]()
    var seniorManagement = [Employee]()
    var staff = [Employee]()
    var allEmployees = [[Employee]]()
    var employeeTypes: [String] = [EmployeeType.Executive.rawValue,
                                   EmployeeType.SeniorManagement.rawValue,
                                   EmployeeType.Staff.rawValue,
                                   EmployeeType.Intern.rawValue]
    
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
        createEVC.company = company
        createEVC.delegate = self
        let navVC = UINavigationController(rootViewController: createEVC)
        present(navVC, animated: true, completion: nil)
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = [] //fixes bug
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter({ $0.type == employeeType}))
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = employeeTypes[section]
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.navy
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        cell.textLabel?.text = employee.name
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormatter.string(from: birthday)) "
        }
        //        if let taxId = employee.employeeInformation?.taxId {
        //            cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
        //        }
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    // MARK: - Protocol
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.index(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath.init(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
}
