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
        NavigationView{
            ZStack{
                Color.customBackgroundColor
                    .ignoresSafeArea()
                VStack{
                    Button(action: {
                        viewModel.toggleAddMedication()
                        viewModel.isEditMode = false
                        
                    }, label: {
                        Text("Add Medication")
                    })
                    
                    ScrollView
                    {
                        ForEach(viewModel.medications){medicine in
                            MedicationRow(medicine: medicine,viewModel: viewModel)
                        }
                        .padding(.vertical,20)
                    }

                    .sheet(isPresented: $viewModel.isPresented) {
                        AddMedicationView(viewModel:viewModel)
                    }
                }
            }
        }
       
    }
}

#Preview {
    MedicationListView(viewModel: MedicationListViewModel())
}
