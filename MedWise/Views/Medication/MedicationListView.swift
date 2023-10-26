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
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.toggleAddMedication()
                            viewModel.isEditMode = false
                        }) {
                            Image(systemName: "plus.circle.fill")
                                                       .resizable()
                                                       .frame(width: 60, height: 60)
//                                                       .background(Circle())
                                                       .foregroundColor(.white)
                                                       .padding(.bottom, 60)
                                                       .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
       
    }
}

#Preview {
    MedicationListView(viewModel: MedicationListViewModel())
}
