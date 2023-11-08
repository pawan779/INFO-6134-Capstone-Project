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
                    HStack {
                        ZStack(alignment: .trailing){
                            TextField(" Search Medicine", text: $viewModel.searchTerm)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .onChange(of: viewModel.searchTerm) { newValue in viewModel.filterSearchResults()
                                }

                            if !viewModel.searchTerm.isEmpty {
                                Button(action: {
                                    viewModel.searchTerm = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 20)
                                }
                            }
                        }



                        Button(action: {
                            if viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty {
                                viewModel.isFilterSheetPresented.toggle()
                            } else {
                                viewModel.selectedFilterData = ""
                                viewModel.selectedSortedValue = ""
                            }
                        }) {
                            Text("\((viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty) ? "Filter" : "Clear")")
                            Image(systemName: (viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty) ? "chevron.down" : "xmark.circle.fill" )
                                .padding(.top, 6)
                        }
                        .padding(.trailing, 10)
                        .foregroundColor(.white)
                        .sheet(isPresented: $viewModel.isFilterSheetPresented, content: {
                            MedicationFilterView(viewModel: viewModel)
                                .presentationDetents([.height(250)])

                        })
                    }


                    ScrollView
                    {
                        ForEach(viewModel.listData){medicine in
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
                            viewModel.clear()
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
