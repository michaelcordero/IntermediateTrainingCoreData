//
//  CreateCompanyViewController.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/4/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit
import CoreData

// MARK: - CreateCompanyViewController
class CreateCompanyViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded  else { return }
            datePicker.date = founded
            companyImageView.image = UIImage(data: (company?.imageData!)!) ?? #imageLiteral(resourceName: "select-photo")
            setupCircularImageStyle()
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select-photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    // MARK: - ViewController Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = UIColor.navy
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    // MARK: - Private Functions
    
    @objc private func handleSelectPhoto() {
        print("Trying to select photo...")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            updateCompany()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            companyImageView.image = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
    private func updateCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company?.imageData = imageData
        }
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
        } catch let updateError {
            print("Failed to update company changes: ", updateError)
        }
       
    }
    private func createCompany() {
        print("trying to save..")
        
        //initialization of our Core Data Stack
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        // perform save
        do {
            try context.save()
            //success
            dismiss(animated: true, completion: {self.delegate?.didAddCompany(company: company as! Company)})
        } catch let error {
            print("Failed to save company: ", error)
        }

    }
    
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2  //makes image circular
        companyImageView.clipsToBounds = true       //makes image circle
        companyImageView.layer.borderColor = UIColor.navy.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    private func setupUI() {
        //Light Blue Background View
        let lightBlueBackgroundView = UIView()
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        //Company Image View
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //Name Label
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        //Name Text Field
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        // DatePicker
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        
        
    }
}


