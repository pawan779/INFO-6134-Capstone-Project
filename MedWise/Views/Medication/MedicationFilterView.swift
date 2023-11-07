//
//  MedicationFilterView.swift
//  MedWise
//
//  Created by Rajeev Sharma on 2023-11-06.
//

import SwiftUI

struct MedicationFilterView: View {
    
    @ObservedObject var viewModel: MedicationListViewModel
    
    var body: some View{
        
        ZStack {
            Color.customBackgroundColor.ignoresSafeArea()
            
            VStack{
                
                Text("Medicine Count")
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom,10)
                    .foregroundColor(.gray)
                
                HStack {
                    FilterButtonView(label: "< 5", action: {
                        // Handle the action for "< 5" button
                        // Set the selectedMedicineCount accordingly
                        viewModel.filterMedication(minVal: 5, maxVal: 0)
                        viewModel.selectedFilterData = "less than 5 days"
                        viewModel.maxFilterVal = 0
                        viewModel.minFilterVal = 5
                        
                    }, color: .red)

                    FilterButtonView(label: "5 - 10", action: {
                        // Handle the action for "5 - 10" button
                        // Set the selectedMedicineCount accordingly
                        
                        viewModel.filterMedication(minVal: 5, maxVal: 10)
                        viewModel.selectedFilterData = "5 to 10 days"
                        viewModel.minFilterVal = 5
                        viewModel.maxFilterVal = 10
                    }, color: .yellow)

                    FilterButtonView(label: "10 >", action: {
                        // Handle the action for "10 >" button
                        // Set the selectedMedicineCount accordingly
                        viewModel.filterMedication(minVal: 0, maxVal: 10)
                        viewModel.selectedFilterData = "more than 10 days"
                        
                        viewModel.minFilterVal = 0
                        viewModel.maxFilterVal = 10
                    }, color: .green)
                }
                .padding(.bottom, 30)
                
                Text("Medicine SortBy")
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.bottom,10)
                    .foregroundColor(.gray)
                
                HStack {
                    SortButtonView(label: "Morning", action: {
                        // Handle the action for "Morning" button
                        // Implement the functionality for sorting by morning
                    })

                    SortButtonView(label: "Day", action: {
                        // Handle the action for "Day" button
                        // Implement the functionality for sorting by day
                    })

                    SortButtonView(label: "Evening", action: {
                        // Handle the action for "Evening" button
                        // Implement the functionality for sorting by evening
                    })
                }
            }
        }
    }
}

struct FilterButtonView: View {
    let label: String
    let action: () -> Void
    let color: Color
    var buttonSize: CGSize = CGSize(width: 100, height: 30)

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: buttonSize.width, height: buttonSize.height)
                    .cornerRadius(8)

                Text(label)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SortButtonView: View {
    let label: String
    let action: () -> Void
    var buttonSize: CGSize = CGSize(width: 100, height: 30)

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: buttonSize.width, height: buttonSize.height)
                    .cornerRadius(8)

                Text(label)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    MedicationFilterView(viewModel: MedicationListViewModel())
}
