//
//  CreateCompanyViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/4/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit

class CreateCompanyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.navy
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
