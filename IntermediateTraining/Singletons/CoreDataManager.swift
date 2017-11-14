//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/5/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//


import Foundation
import CoreData

struct CoreDataManager {
    //Singleton
    static let shared = CoreDataManager()
    // NSPersistentContainer
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTraining")
        container.loadPersistentStores(completionHandler: {(storeDescription, err) in if let err = err {
            fatalError("Loading of store failed: \(err)")
            }})
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        let context = persistentContainer.viewContext
        do{
           let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr{
            print("Failed to fetch companiess: ", fetchErr)
            return []
        }
    }
    
    func reset() -> Void {
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
        } catch let deleteError {
            print("Failed to delete objects from Core Data: ", deleteError)
        }
    }
    
    func createEmployee(employeeName: String) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return (employee, nil)
        } catch let saveError {
            print("Failed to create employee: ",saveError)
            return (nil, saveError)
        }
    }
}
