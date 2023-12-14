//
//  ContentView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .medication
    @ObservedObject var notificationViewModel: NotificationViewModel = NotificationViewModel()
    
    init() {
        
        notificationViewModel.requestNotificationPermissions()
        
       UITabBar.appearance().isHidden = true
        DatabaseHelper.shared.createTableIfNotExists()
        
        
//        DatabaseHelper.shared.deleteAllMedications()
    
    }

    var body: some View {
        ZStack{
           VStack {
             TabView(selection: $selectedTab){
               ForEach(Tab.allCases, id: \.rawValue) { tab in
                   HStack {
                       if tab == .medication {
                           MedicationListView(viewModel: MedicationListViewModel())
                       } else if tab == .history {
                           HistoryListView(viewModel: HistoryViewModel())
                       } else if tab == .appointment {
                           AppointmentListView(viewModel: AppointmentViewModel())
                       } else {
                           SettingsView(viewModel: ProfileViewModel(user: User(id: 1, name: "String", gender: "String", age: "2", weight: "String")), appointmentViewModel: AppointmentViewModel(), id: 1)
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
    static let customBackgroundColor = Color(red: 0.23, green: 0.29, blue: 0.38)
    static let listViewColor = Color(red: 0.09, green: 0.14, blue: 0.26)
}

#Preview {
    ContentView()
}

