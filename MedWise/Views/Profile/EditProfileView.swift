//
//  EditProfileView.swift
//  MedWise
//
//  Created by Cyrus Shakya on 2023-11-04.
//

import SwiftUI

//enum Gender2: String, CaseIterable, Identifiable {
//    case male, female, others
//    var id: Self { self }
//}

struct EditProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var age: String
    @State private var weight: String
    @State var selectedGender: Gender = .male
    
    @State private var isNavigationActive = false
    
    @State private var isInputValid = false
    @State private var isEmailValid = false
    @State private var isPhoneValid = false
    @State private var isAgeValid = false
    @State private var isWeightValid = false
    
    @State private var isShowingAlert = false
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.loadUserFromDatabase().name)
        _email = State(initialValue: viewModel.loadUserFromDatabase().email ?? "" )
        _phone = State(initialValue: viewModel.loadUserFromDatabase().phone ?? "")
        _age = State(initialValue: viewModel.loadUserFromDatabase().age)
        _weight = State(initialValue: viewModel.loadUserFromDatabase().weight)
        _selectedGender = State(initialValue: Gender(rawValue: viewModel.loadUserFromDatabase().gender) ?? .male)
    }
    
    func isNumericPhoneNumber(_ phone: String) -> Bool {
        // Use the `CharacterSet.decimalDigits` to check if the string contains only digits
        let numericCharacterSet = CharacterSet.decimalDigits
        let hasOnlyDigits = phone.rangeOfCharacter(from: numericCharacterSet.inverted) == nil
        
        // Check if the length is exactly 10 characters
        let hasValidLength = phone.count == 10
        
        return hasOnlyDigits && hasValidLength
    }
    
    
    
    var body: some View {
        
        Form {
            
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onChange(of: name) { newName, _ in
                    isInputValid = name.isEmpty
                }
            
            if isInputValid {
                Text("Name must be not empty")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .onChange(of: email) { newEmail, _ in
                    isEmailValid = email.isEmpty
                }
            
            if isEmailValid {
                Text("Email must be not empty")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            TextField("Phone", text: $phone)
                .textFieldStyle(.roundedBorder)
                .onChange(of: phone) { newPhone, _ in
                    isPhoneValid = !(isNumericPhoneNumber(phone))
                }
            
            if isPhoneValid {
                Text("Phone not valid")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            TextField("Age", text: $age)
                .textFieldStyle(.roundedBorder)
            
                .onChange(of: age) { newAge, _ in
                    if (18...100).contains(Int(age) ?? 0) {
                        isAgeValid = false //valid age
                    } else {
                        isAgeValid = true
                    }
                }
            
            if isAgeValid {
                
                Text("Age must be between 18 and 100")
                    .foregroundColor(.red)
                    .font(.caption)
                
                
            }
            
            
            TextField("Weight", text: $weight)
                .textFieldStyle(.roundedBorder)
                .onChange(of: weight) { newValue, _ in
                    if (10...200).contains(Float(weight) ?? 0.0) {
                        isWeightValid = false //valid weight
                    }
                    else {
                        isWeightValid = true
                    }
                }
            
            if isWeightValid {
                
                Text("Weight must be between 10 and 200")
                    .foregroundColor(.red)
                    .font(.caption)
                
            }
            
            HStack{
                Text("Gender:")
                Picker("Gender",selection: $selectedGender) {
                    ForEach(Gender.allCases) { gender in
                        Text(gender.rawValue.capitalized)
                    }
                }
                .pickerStyle(.palette)
                .padding()
            }
            
            
            
    
        }
        .background(
            NavigationLink(destination: ProfileView(viewModel: viewModel), isActive: $isNavigationActive) {
                ProfileView(viewModel: viewModel)
            }
        )
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Invalid Data"),
                message: Text("Please check your input data and try again."),
                dismissButton: .default(Text("OK"))
            )
        }
        Button("Update") {
            if (isInputValid || isEmailValid || isPhoneValid || isAgeValid || isWeightValid) {
                isShowingAlert = true //show error
            } else {
                viewModel.updateUserProfile(name: name, email: email, phone: phone, gender: selectedGender.rawValue, age: age, weight: weight)
                
                isNavigationActive = true
            }
        }
        .frame(maxWidth: .infinity,maxHeight: 50)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(8)
        .padding()
        .padding(.bottom,60)
        
    }
    
}

#Preview {
    EditProfileView(viewModel: ProfileViewModel(user: User(id: 1, name: "John Doe",email: "",phone: "" ,gender: "female", age: "22", weight: "56")))
}
