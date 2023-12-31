//
//  HistoryListView.swift
//  MedWise
//
//  Created by Pawan Dharel on 11/23/23.
//

import SwiftUI
import MessageUI

struct HistoryListView: View {
    
    @ObservedObject var viewModel = HistoryViewModel()

    @State private var showAlert = false
    

//    @State private var showMailView = false
    @State private var showShareSheet = false
//    @State private var showAlert = false

    var body: some View {
        
        
        GeometryReader { geometry in
            NavigationView{
                
                ZStack{
                    Color.customBackgroundColor
                        .ignoresSafeArea()
                    
                    // Shake Features
                    Text("")
                        .onShake {
                            print("Device shaken!")
                            showAlert = true
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Healthy Tips of the Day"),
                                message: Text(viewModel.healthTips.randomElement() ?? "No tips available"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    
                    VStack(alignment: .leading){
                        
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleShowSkippedMedicines()
                            }) {
                                Text(!viewModel.showSkippedMedicines ? "Show Skipped Medicines" : "Show All History")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.clear)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                
                                
                            }
                        }
                        Button(action: {
                            self.showShareSheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                                Text("Share History")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.customBackgroundColor)
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showShareSheet, content: {
                            ShareSheet(activityItems: [viewModel.createCSV()])
                        })

                     
                        
                        ScrollView
                        {
                            
                            ForEach(viewModel.history.indices, id: \.self) { index in
                                VStack(alignment: .leading){
                                    let groupedEntry = viewModel.history[index]
                                    HStack{
                                        Image(systemName: "clock.fill")
                                        
                                        Text("\(groupedEntry["date"] as? String ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .padding(.bottom, 5)
                                    }
                                    .foregroundColor(.white)
                                    if let historyArray = groupedEntry["history"] as? [[String: Any]] {
                                        ForEach(historyArray.indices, id: \.self) { historyIndex in
                                            let historyEntry = historyArray[historyIndex]
                                            let isTaken = historyEntry["isTaken"] as? Bool
                                            
                                            HStack{
                                                
                                                Text("\(HelperFunction().formattedTime(historyEntry["takenDate"] as! Date))")
                                                    .opacity(historyEntry["isTaken"] as? Bool == true ? 1 : 0)
                                                
                                                Text("\(historyEntry["medicineName"] as? String ?? "")")
                                                
                                                
                                                Text("\(isTaken ?? false ? "(Taken)" : "(Skiped)")")
                                            }
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.leading, 30)
                                        }
                                    }
                                }
                                
                                .padding(.vertical,20)
                            }
                        }
                        .padding(.leading, 10)
                        
                    }
                }
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.customBackgroundColor)
            .onAppear {
                viewModel.fetchHistoryGroupedByDate()
            }
        }
        
    }
}

#Preview {
    HistoryListView(viewModel: HistoryViewModel())
}
