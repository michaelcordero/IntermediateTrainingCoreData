//
//  CompaniesViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/4/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit

class CompaniesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Companies"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
    }
}
