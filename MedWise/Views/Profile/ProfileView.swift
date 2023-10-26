//
//  ProfileView.swift
//  MedWise
//
//  Created by Cyrus Shakya on 2023-10-16.
//

import SwiftUI

struct ProfileView: View {
//    @State private var user = User()
    
    var body: some View {
        NavigationView {
                   List {
                       Section(header: Text("Profile Information")) {
                           ProfileRow(systemName: "person.circle.fill", title: "Name", value: "John Doe")
                           ProfileRow(systemName: "envelope.fill", title: "Email", value: "")
                           ProfileRow(systemName: "phone.fill", title: "Phone", value: "")
                       }
                       
                       Section(header: Text("Additional Information")) {
                           ProfileRow(systemName: "figure.dress.line.vertical.figure", title: "Gender", value: "Male")
                           ProfileRow(systemName: "birthday.cake.fill", title: "Age", value: "23")
                           ProfileRow(systemName: "scalemass.fill", title: "Weight (in kg)", value: "65")
                           
                       }
                       
                      
                   }
                   .listStyle(SidebarListStyle())
                   .navigationTitle("Profile")
            
//            HStack {
//                Button(action: {
//                    // Button 1 action
//                }) {
//                    Text("Edit profile")
//                        .font(.title3)
//                        .padding()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(15)
//                        .foregroundColor(.white)
//                }
//
//                Button(action: {
//                    // Button 2 action
//                }) {
//                    Text("Delete data")
//                        .font(.title3)
//                        .padding()
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .background(Color.red)
//                        .cornerRadius(15)
//                        .foregroundColor(.white)
//                }
//            }
           
               }
        
       

        
    
    }
}

#Preview {
    ProfileView()
}
