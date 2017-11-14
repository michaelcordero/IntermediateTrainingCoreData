//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/9/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    // MARK: - Properties
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            companyImageView.image = UIImage(data: (company?.imageData!)!) ?? #imageLiteral(resourceName: "select-photo")
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "select-photo"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.navy.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .teal
        
        // CompanyImageView
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        //NameFoundedDateLabel
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
