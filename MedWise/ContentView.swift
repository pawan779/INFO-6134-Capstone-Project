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
    }

    var body: some View {
    

        ZStack{
           VStack {
             TabView(selection: $selectedTab){
               ForEach(Tab.allCases, id: \.rawValue) { tab in
                   HStack {
                       if tab == .medication {
                           MedicationListView()
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

#Preview {
    ContentView()
}

