//
//  MedicationViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

 class MedicationListViewModel: ObservableObject {
    
   @Published var isPresented: Bool = false
     @Published var showAddMedicationNotify: Bool = false
     @Published var medicineName: String = ""
      @Published var selectedFrequency: Int = 1
     @Published var selectedTimes: [Date] = [Date()]
     let frequencyOptions = ["Once a day", "Twice a day", "Three times a day", "Four times a day"]
     @Published var medications: [Medication] = []
     
  
    
    
    func toggleAddMedication(){
        isPresented.toggle()
        
    }
    

     internal init() {
        
        fetchMedications()
    
       
    }
    
    func fetchMedications() {
           medications = DatabaseHelper.shared.fetchMedications()
        print(medications)
       }
    
    func addMedication(medicineName: String, reminderTime: [Date]) {
           DatabaseHelper.shared.addMedication(medicineName: medicineName, reminderTime: reminderTime)
           fetchMedications()
       }

}
    

