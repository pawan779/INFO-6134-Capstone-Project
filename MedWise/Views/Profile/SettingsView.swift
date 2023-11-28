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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    
    @State var name: String = ""
    @State var age = ""
    @State var gender: String = ""
    @State var weight: String = ""
    
    @State private var isInputValid = false
    @State private var isAgeValid = false
    @State private var isWeightValid = false
    @State private var showingMap = false
    
    @State var isPresented: Bool = true
    @State var selectedGender: Gender = .male
    
    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Settings")) {
                    NavigationLink(destination: ProfileView(viewModel: viewModel)) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                        Text("Profile")
                    }
                    
                    NavigationLink(destination: ProfileView(viewModel: viewModel) ) {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.blue)
                        Text("Medicine Log")
                    }
                    Button(action: {
                          showingMap = true
                      }) {
                          HStack {
                              Image(systemName: "location.fill").foregroundColor(.blue)
                              Text("Drugstore near me")
                                  .foregroundColor(.black)
                          }
                      }
                      .sheet(isPresented: $showingMap) {
                          MapView() // Present MapView
                      }
                }
                
                Section(header: Text("Preference")) {
                    NavigationLink(destination: ProfileView(viewModel: viewModel)) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                        Text("App Preference")
                    }
                    
                    NavigationLink(destination: ProfileView(viewModel: viewModel)) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                        Text("Support")
                    }
                }
            }
        }
        .onAppear {
            if (viewModel.loadUserFromDatabase().name == "String" )  {
                isPresented = true
            }
            else{
                isPresented = false
            }
        }
        .sheet(isPresented: $isPresented, content: {
            VStack {
                // Name TextField
                TextField("Enter Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: name) { newName, _ in
                        isInputValid = name.isEmpty
                        
                    }

                if isInputValid {
                    HStack {
                        Text("Name must be not empty")
                            .foregroundColor(.red)
                            .font(.caption)
                        Spacer() // Pushes the text to the left
                    }
                    .padding()
                    
                }
                
                
                // Age TextField
                TextField("Enter Age", text: $age)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .keyboardType(.numberPad)
                    .onChange(of: age) { newAge, _ in
                        if (18...100).contains(Int(age) ?? 0) {
                            isAgeValid = false //valid age
                        } else {
                            isAgeValid = true
                        }
                    }

                if isAgeValid {
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
                    .onChange(of: weight) { newValue, _ in
                        if (10...200).contains(Float(weight) ?? 0.0) {
                            isWeightValid = false //valid weight
                        }
                        else {
                            isWeightValid = true
                        }
                    }
                
                if isWeightValid {
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
                    viewModel.addUserToDatabase(name: name, email: "", phone: "", gender: selectedGender.rawValue, age: age, weight: weight)
                }, label: {
                    Text("Submit")
                })
                .disabled(isInputValid || isAgeValid || isWeightValid)
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
    SettingsView(viewModel: ProfileViewModel(user: User(id: 1, name: "John Doe", gender: "female", age: "22", weight: "56")))
}
