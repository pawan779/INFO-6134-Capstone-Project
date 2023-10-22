//
//  MedicationListView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct MedicationListView: View {
    
    @State var viewModel: MedicationListViewModel
    
   
    
    func fetchMedicine(){
        viewModel.fetchMedications()
    }
    
    var body: some View {
        
        VStack{
            List{
                ForEach(viewModel.medications){medicine in
                    Text("\(medicine.medicineName)")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                
            }
            
            Button(action: {
                viewModel.toggleAddMedication()
                
            }, label: {
                Text("Add Medication")
            })
            .sheet(isPresented: $viewModel.showAddMedication) {
                AddMedicationView(viewModel: MedicationListViewModel(selectedFrequency: ""))
            }
        }
    }
}

#Preview {
    MedicationListView(viewModel: MedicationListViewModel(selectedFrequency: ""))
}
