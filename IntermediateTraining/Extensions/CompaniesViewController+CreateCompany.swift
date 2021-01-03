//
//  CompaniesViewController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/12/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation
import UIKit

extension CompaniesViewController: CreateCompanyControllerDelegate {
    // MARK: - Protocols
    func didEditCompany(company: Company) {
        //update tableview somehow
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: (companies.count) - 1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
