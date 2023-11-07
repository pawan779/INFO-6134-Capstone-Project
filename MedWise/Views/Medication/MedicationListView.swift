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
                            if viewModel.selectedFilterData.isEmpty {
                                viewModel.isFilterSheetPresented.toggle()
                            } else {
                                viewModel.selectedFilterData = ""
                            }
                        }) {
                            Text("\(viewModel.selectedFilterData.isEmpty ? "Filter" : "Clear")")
                            Image(systemName: viewModel.selectedFilterData.isEmpty ? "chevron.down" : "xmark.circle.fill" )
                                .padding(.top, 6)
                        }
                        .padding(.trailing, 10)
                        .foregroundColor(.white)
                        .sheet(isPresented: $viewModel.isFilterSheetPresented, content: {
                            MedicationFilterView(viewModel: viewModel)
                                .presentationDetents([.height(250)])

                        })
                    }
//                    if (!viewModel.selectedFilterData.isEmpty) {
//                        HStack{
//                            Text("Fitler: \(viewModel.selectedFilterData)")
//                            
//                            Button(action: {
//                                viewModel.selectedFilterData = ""
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                                    .padding(.trailing, 20)
//                            }
//                        }
//                    }
             
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

//struct BottomSheetView: View {
//    
//    
//    var buttonSize: CGSize = CGSize(width: 100, height: 30)
//    
//    var body: some View{
//        
//        ZStack {
//            Color.customBackgroundColor.ignoresSafeArea()
//            
//            VStack{
//                
//                Text("Medicine Count")
//                    .font(.headline)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                    .padding(.bottom,10)
//                    .foregroundColor(.gray)
//                
//                HStack{
//                    Button(action: {
//                        selectedMedicineCount = 5
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.red)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text(" < 5")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    Button(action: {
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.yellow)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text("5 - 10")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    Button(action: {
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.green)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text("10 >")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//                .padding(.bottom,30)
//                
//                Text("Medicine SortBy")
//                    .font(.headline)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                    .padding(.bottom,10)
//                    .foregroundColor(.gray)
//                
//                
//                HStack{
//                    Button(action: {
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.gray)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text("Morning")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    Button(action: {
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.gray)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text("Day")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    Button(action: {
//                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.gray)
//                                .frame(width: buttonSize.width, height: buttonSize.height)
//                                .cornerRadius(8)
//                            
//                            Text("Evening")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}


#Preview {
    MedicationListView(viewModel: MedicationListViewModel())
}
