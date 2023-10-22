//
//  MedicationNotifyView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct MedicationFrequencyView: View {
    
    @State var viewModel: MedicationListViewModel
    
    var body: some View {
        
        NavigationView{
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
                        
                        List{
                            ForEach(viewModel.frequencyOptions, id:\.self){data in
                                NavigationLink(data) {
                                    SupportView()
                                }
                            }
                        
                        }
                        .frame(maxHeight: 250)
                        .cornerRadius(30.0)
                        
                        .background(Color.blue)
                        
                    }
                
                    Spacer()
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.blue)
                
            }
       
        }
    }
    
}


#Preview {
    MedicationFrequencyView(viewModel: MedicationListViewModel())
}
