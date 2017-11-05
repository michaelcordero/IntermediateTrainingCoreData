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
}
