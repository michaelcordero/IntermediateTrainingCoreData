//
//  CompaniesController+UITableView.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/12/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation
import UIKit

extension CompaniesViewController {
    // MARK: - Table Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CompanyCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        cell.company = companies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company: ", company.name ?? "")
            // remove company from tableView
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // delete company from CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company) // deletes from memory context
            do {
                try context.save() // actually persists the deletion
                print("Company successfully deleted.")
            } catch let saveError {
                print("Failed to delete company: ", saveError)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.navy
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath){
        print("Editing company in seperate function")
        let editCompanyController = CreateCompanyViewController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true, completion: nil)
    }
}
