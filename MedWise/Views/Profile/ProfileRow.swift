//
//  ProfileRow.swift
//  MedWise
//
//  Created by Cyrus Shakya on 2023-10-21.
//

import SwiftUI

struct ProfileRow: View {
   
        var systemName: String
          var title: String
          var value: String
          
          var body: some View {
              HStack {
                  Image(systemName: systemName)
                      .foregroundColor(.blue)
                  Text(title)
                  Spacer()
                  Text(value)
                      .foregroundColor(.gray)
              }
    }
}

#Preview {
    ProfileRow(systemName:"person.circle.fill", title: "Name", value: "Cyrus Shakya")
}
