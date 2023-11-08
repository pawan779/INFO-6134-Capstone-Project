//
//  User.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation

struct User : Identifiable{
    var id: Int
    var name: String
    var email: String?
    var phone: String?
    var gender: String
    var age: String
    var weight: String
//    var medication: [Medication]
    
    init(id: Int, name: String, email: String? = nil, phone: String? = nil, gender: String, age: String, weight: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.gender = gender
        self.age = age
        self.weight = weight
    }
    
}
