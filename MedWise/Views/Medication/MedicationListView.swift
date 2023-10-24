//
//  MedicationListView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct MedicationListView: View {
    
    @ObservedObject var viewModel = MedicationListViewModel()
    
   
    
    func fetchMedicine(){
        viewModel.fetchMedications()
       
    }
    
    var body: some View {
        
        ZStack{
            Color.customBackgroundColor
                .ignoresSafeArea()
            VStack{
                Button(action: {
                    viewModel.toggleAddMedication()
                    
                }, label: {
                    Text("Add Medication")
                })
       
               
                .sheet(isPresented: $viewModel.isPresented) {
                    AddMedicationView(viewModel:viewModel)
                }
            }
            
        }
       
    }
}

#Preview {
    MedicationListView(viewModel: MedicationListViewModel())
}
