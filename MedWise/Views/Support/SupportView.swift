//
//  SupportView.swift
//  MedWise
//
//  Created by Nabin Pun on 10/21/23.
//

import SwiftUI
import MessageUI

struct SupportView: View {
    
    @State private var fullName: String = ""
    @State private var email: String = "shakya.cyrus@gmail.com"
    @State private var feedback: String = ""
    
    @State private var isShowingMailView = false
    @State private var showAlert = false
    
    
    func sendEmail() {
        
        let url = URL(string: "mailto:\(email)?subject=Feedback from \(fullName)&body=\(feedback)")
        
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    var body: some View {
        ZStack{
            Color.customBackgroundColor
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Image(systemName: "info.square")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("We'd love to hear from you")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding()
                   
                }
                .padding(.bottom,10)
              
                VStack(alignment: .leading){
                    Text("Enter Name: ")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading,12)
                        .padding(.top,10)
                    
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .padding(.leading,12)
                        .padding(.trailing,12)
                }

                VStack(alignment: .leading){
                    Text("Feedback: ")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading,12)
                        .padding(.top,10)
                    
                    TextEditor(text: $feedback)
                        .frame(height: 120)
                        .background(Color.white)
                        .lineSpacing(2.0)
                        .padding(.leading,12)
                        .padding(.trailing,12)
                }.padding(.bottom,15)
                
                
                
                Button(action: {
                    if fullName.isEmpty || feedback.isEmpty {
                        showAlert = true
                    } else {
                        sendEmail()
                    }
                    
                }) {
                    Text("Submit")
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                
                Spacer()  // Add Spacer at the beginning
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Form"),
                    message: Text("Please fill in all the required fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .padding()
        }
    }
}

#Preview {
    
    SupportView()
}
