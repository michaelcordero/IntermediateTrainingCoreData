//
//  CreateCompanyControllerDelegate.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/7/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation

// Custom Delegation

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}
