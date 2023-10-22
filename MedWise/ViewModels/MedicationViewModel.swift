//
//  MedicationViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI
import Observation



@Observable
final class MedicationListViewModel: ObservableObject{
    
    var showAddMedication: Bool = false
    var showAddMedicationNotify: Bool = false
    var medicineName: String = ""
    var selectedFrequency: String = "Once a day"
    var selectedTimes: [Date]
    let frequencyOptions = ["Once a day", "Twice a day", "Three times a day", "Four times a day"]
    var medications: [Medication] = []
    
    
    func toggleAddMedication(){
        showAddMedication = true
        
    }
    
    func closeAddMedication(){
        showAddMedication = false
    }
    
 
    internal init(selectedFrequency: String) {
        
        var numberOfTimes: Int = 4

        if selectedFrequency == frequencyOptions[0] {
            numberOfTimes = 1
        } else if selectedFrequency == frequencyOptions[1] {
            numberOfTimes = 2
        } else if selectedFrequency == frequencyOptions[2] {
            numberOfTimes = 3
        }

        selectedTimes = Array(repeating: Date(), count: numberOfTimes)
        
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
    

