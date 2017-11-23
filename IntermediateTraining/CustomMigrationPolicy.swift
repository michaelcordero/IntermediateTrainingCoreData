//
//  CustomMigrationPolicy.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/22/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation
import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    // Transformation Function
    @objc func transferNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
