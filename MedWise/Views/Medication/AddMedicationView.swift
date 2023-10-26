//
//  AddMedicationView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct AddMedicationView: View {
   
    @ObservedObject var viewModel: MedicationListViewModel
    
   
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                VStack {
                    HStack{
                        
                        Image(systemName: "pills")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("What is the name of the medicine?")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                    TextField("Medication Name", text: $viewModel.medicineName)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Spacer()
                
                    NavigationLink(destination: viewModel.isEditMode ? AnyView(MedicationReminderView(viewModel: viewModel)) : AnyView(MedicationFrequencyView(viewModel: viewModel))) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                    }
                    
               
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.customBackgroundColor)
                
            }
        }
        
     

    }
}

#Preview {
    AddMedicationView(viewModel: MedicationListViewModel())
}
