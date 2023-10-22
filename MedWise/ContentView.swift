//
//  ContentView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .medication
    
    init() {
       UITabBar.appearance().isHidden = true
        DatabaseHelper.shared.createTableIfNotExists()
    }

    var body: some View {
        ZStack{
           VStack {
             TabView(selection: $selectedTab){
               ForEach(Tab.allCases, id: \.rawValue) { tab in
                   HStack {
                       if tab == .medication {
                           MedicationListView(viewModel: MedicationListViewModel(selectedFrequency: ""))
                       } else if tab == .history {
                           SupportView()
                       } else {
                           ProfileView()
                       }
                   }
               
                .tag(tab)
              }
             }
           }
           VStack {
             Spacer()
             MyTabBar(selectedTab: $selectedTab)
            }
          }
     
        
    }
}

extension Color {
    static let customBackgroundColor = Color(red: 0.2, green: 0.4, blue: 0.6)
}

#Preview {
    ContentView()
}

