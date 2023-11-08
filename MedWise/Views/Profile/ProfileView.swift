//
//  ProfileView.swift
//  MedWise
// 
//  Created by Cyrus Shakya on 2023-10-16.
//

import SwiftUI

struct ProfileView: View {
    //    @State private var user = User()
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var shouldNavigateToSettings = false

    @State private var isDeleteProfileAlertPresented = false
    @State private var isEditProfileViewPresented = false
    
    func deleteProfile() {
        
        print("deleted clicked !!")
        print(viewModel.loadUserFromDatabase().id)
        viewModel.deleteUser(id: viewModel.loadUserFromDatabase().id)
        
        
    }
    
    var body: some View {
        
        List {
            
            Section(header: Text("Profile Information")) {
                ProfileRow(systemName: "person.circle.fill", title: "Name", value: viewModel.loadUserFromDatabase().name)
                ProfileRow(systemName: "envelope.fill", title: "Email", value: viewModel.loadUserFromDatabase().email ?? "")
                ProfileRow(systemName: "phone.fill", title: "Phone", value:viewModel.user.phone ??  "")
            }
            
            Section(header: Text("Additional Information")) {
                ProfileRow(systemName: "figure.dress.line.vertical.figure", title: "Gender", value: viewModel.loadUserFromDatabase().gender)
                ProfileRow(systemName: "birthday.cake.fill", title: "Age", value: viewModel.loadUserFromDatabase().age)
                ProfileRow(systemName: "scalemass.fill", title: "Weight (in kg)", value: viewModel.loadUserFromDatabase().weight)
                
            }
            
            
           
            
            
            
            
//            VStack{
//                Button(action: {
//                    // Show the confirmation dialog when the button is tapped
//                    isDeleteProfileAlertPresented = true
//                }) {
//                    Text("Delete Profile").font(.title3)
//                        .padding()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .background(Color.red)
//                        .cornerRadius(15)
//                        .foregroundColor(.white)
//             
//                }
//              
//            }
          
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Profile")
        .alert(isPresented: $isDeleteProfileAlertPresented) {
            Alert(
                title: Text("Delete Profile"),
                message: Text("Are you sure you want to delete your profile? This action cannot be undone."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete"), action: {
                    deleteProfile()
                })
            )
        }
        
        
        
        NavigationLink(
            destination: EditProfileView(viewModel: viewModel),
            label: {
                Text("Edit profile")
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
        )
        .buttonStyle(PlainButtonStyle())
        .padding()
        .padding(.bottom,60)
        
        
        
        
    }
}

#Preview {
    ProfileView(viewModel:ProfileViewModel(user: User(id: 1, name: "John Doe", gender: "female", age: "22", weight: "56")))
}
