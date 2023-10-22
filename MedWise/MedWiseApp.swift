//
//  MedWiseApp.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/12/23.
//

import SwiftUI

@main
struct MedWiseApp: App {
    let dbHelper = DatabaseHelper.shared
      

    
      init() {
          dbHelper.createTableIfNotExists()
      }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
