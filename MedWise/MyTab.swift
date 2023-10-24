//
//  MyTab.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
   case medication
   case history
   case setting
}

struct MyTabBar: View {
      @Binding var selectedTab: Tab
      private var fillImage: String {
          selectedTab.rawValue == "medication" ? "pills.fill" : selectedTab.rawValue == "history" ? "clock.fill" : "gear.circle.fill"
          
         
     }
    
    
    private func unfillImage(tab: Tab)-> String {
        tab.rawValue == "medication" ? "pills" : tab.rawValue == "history" ? "clock" : "gear.circle"
    }
    
    
     var body: some View {
        VStack {
            
           HStack {
             ForEach(Tab.allCases, id: \.rawValue) { tab in
                 Spacer()
                 Image(systemName: selectedTab == tab ? fillImage : unfillImage(tab: tab))
                     .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                     .foregroundColor(selectedTab == tab ? .white : .gray)
                     .font(.system(size: 25))
                     .onTapGesture {
                         withAnimation(.easeOut(duration: 0.3)){
                              selectedTab = tab
                          }
                     }
                    
                 Spacer()
               }
            }
            .frame(width: nil, height: 50)
            .background(Color.customBackgroundColor)
            .cornerRadius(10)
       }
         
    }
}

struct MyTabBar_Previews: PreviewProvider {
     static var previews: some View {
         MyTabBar(selectedTab: .constant(.medication))
     }
}
