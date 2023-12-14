//
//  NotificationListView.swift
//  MedWise
//
//  Created by Rajeev Sharma on 2023-12-13.
//

import SwiftUI

struct NotificationListView: View {
    
    @State private var isNotificationEnabled = false

    var body: some View {
        List {
            Toggle("Notifications", isOn: $isNotificationEnabled)
                .padding()
        }
        .listStyle(InsetGroupedListStyle())
        Spacer()
    }
}

#Preview {
    NotificationListView()
}
