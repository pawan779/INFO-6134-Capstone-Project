//
//  MedicationNotifyView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct MedicationFrequencyView: View {
    
    @ObservedObject var viewModel: MedicationListViewModel = MedicationListViewModel()
//    var medicineName: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        

            GeometryReader { geometry in
                VStack {
                    HStack{
                        
                        Image(systemName: "calendar")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("How often do you take the medicine?")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                    
                    
                    VStack {
                        
                        List {
                            ForEach(Array(viewModel.frequencyOptions.enumerated()), id: \.element) { index, data in
                               
                                NavigationLink(destination: MedicationReminderView( viewModel: viewModel).onAppear(perform: {
                                    viewModel.selectedTimes = Array(repeating: Date(), count: index + 1)
                                })) {
                                    VStack {
                                        Text(data)
                                       
                                    }
                                }
                                
                            }
                        }
                        .frame(maxHeight: 250)
                        .cornerRadius(30.0)
                        
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.customBackgroundColor)
                
            }
               
        

    }
    
}


#Preview {
    MedicationFrequencyView(viewModel: MedicationListViewModel())
}
