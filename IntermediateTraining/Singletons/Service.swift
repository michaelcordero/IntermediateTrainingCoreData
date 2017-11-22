//
//  Service.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/22/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation

struct Service {
    //Singleton
    static let shared = Service()
    //URL String
    let api: String = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompanies() {
        print("Attempting to download companies...")
        guard let url = URL(string: api) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            print("Finished downloading")
            if let error = error {
                print("Failed to download companies: ", error)
                return
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                jsonCompanies.forEach({ print($0.name); $0.employees?.forEach({ print("  \($0.name)"); }) })
            } catch let jsonDecoderError {
                print("Failed to decode: ", jsonDecoderError)
            }
        }).resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
