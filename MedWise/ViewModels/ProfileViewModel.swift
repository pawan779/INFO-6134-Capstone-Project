//
//  ProfileViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    
    var databaseHelper = DatabaseHelper.shared
    @Published var user: User
    
    func addUserToDatabase(name: String,email: String,phone: String, gender: String, age: String, weight: String) {
        databaseHelper.addUser(name: name,email:email,phone:phone ,gender: gender, age: age, weight: weight)
    }
    
    init(user: User) {
        self.user = user
    }	
    
    // needs to be worked
    func loadUserFromDatabase() {
        if let user1 = databaseHelper.getUser() {
       user = user1
        }
    }
       
    
    func updateUserProfile(name: String, email: String?, phone: String?, gender: String, age: String, weight: String) {
            databaseHelper.updateUserProfile(id: user.id, name: name, email: email, phone: phone, gender: gender, age: age, weight: weight)
            
            // After updating the profile, load the updated user data
            loadUserFromDatabase()
        }
    
    func deleteUser(id: Int) {
            databaseHelper.deleteUser(id: id)
            
            loadUserFromDatabase()
        }
    
    func deleteUserProfile(){
        databaseHelper.deleteUserProfile()
        loadUserFromDatabase()
    }
}
    
