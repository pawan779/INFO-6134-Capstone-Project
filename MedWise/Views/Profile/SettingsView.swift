//
//  SettingsView.swift
//  MedWise
//
//  Created by Cyrus Shakya on 10/12/23.
//

import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case male, female, others
    var id: Self { self }
}

struct SettingsView: View {
    
//    @State private var user = User
    
    @State var name: String = ""
    @State var age = ""
    @State var gender: String = ""
    @State var weight: String = ""
    
    @State private var isInputValid = false
    @State private var isAgeValid = true
    @State private var isWeightValid = true
    
    @State var isPresented: Bool = true
    @State var selectedGender: Gender = .male
    
    var body: some View {
        
        NavigationView {
          
            List {
         
                Section(header: Text("Settings")) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                        Text("Profile")
                    }
                    
                    NavigationLink(destination: ProfileView() ) {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.blue)
                        Text("Medicine Log")
                    }
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        Text("Drugstore near me")
                    }
                }
                
                Section(header: Text("Preference")) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                        Text("App Preference")
                    }
                    
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                        Text("Support")
                    }
                }
            }
        }
        
        .sheet(isPresented: $isPresented, content: {
            VStack {
                // Name TextField
                TextField("Enter Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: name) { newValue in isInputValid = !name.isEmpty
                    }
                
                // Age TextField
                TextField("Enter Age", text: $age)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .keyboardType(.numberPad)
                    .onChange(of: age) { newValue in
                        if let age = Int(age) {
                            isAgeValid = (18...100).contains(age)
                        } else {
                            isAgeValid = false
                        }
                    }
                if !isAgeValid {
                    HStack {
                        Text("Age must be between 18 and 100")
                            .foregroundColor(.red)
                            .font(.caption)
                        Spacer() // Pushes the text to the left
                    }
                    .padding()
                    
                }
                
                // Weight TextField
                TextField("Enter Weight (in Kg)", text: $weight)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .keyboardType(.numberPad)
                    .onChange(of: weight) { newValue in
                        if let weight = Float(weight) {
                            isWeightValid = (10...200).contains(weight)
                        } else {
                            isWeightValid = false
                        }
                    }
                
                if !isWeightValid {
                    HStack {
                        Text("Weight must be between 10 and 200")
                            .foregroundColor(.red)
                            .font(.caption)
                        Spacer() // Pushes the text to the left
                    }
                    .padding()
                }
                
                
                //Gender TextField
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
                .padding()
                
                
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Submit")
                })
                .disabled(!isInputValid || !isAgeValid || !isWeightValid)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .foregroundColor(.white)
                .padding()
            }
            //            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //            .background(Color(UIColor(red: 0xDA/255, green: 0x4E/255, blue: 0x25/255, alpha: 1.0)))
            .presentationDetents([.medium, .large, .fraction(0.25), .height(600)], selection: .constant(.large))
            
        })
        
    }
}

#Preview {
    SettingsView()
}
