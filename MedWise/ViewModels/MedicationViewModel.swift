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
    
    @Published  var numberOfTablets: Int = 1
    @Published  var reminderOption: String
    
    let reminderOptions = [
        "1 week before medicine runs out",
        "3 days before medicine runs out",
        "The same day medicine runs out"
    ]
    //     for update
    @Published var dataToBeUpdate: [ReminderTime]
    @Published var isEditMode: Bool = false
    @Published var selectedIndex: Int = 0
    @Published var selectedMedicationId: Int = 0
    
    func toggleAddMedication(){
        isPresented.toggle()
        
    }
    
    
    internal init() {
        
        dataToBeUpdate = [ReminderTime(id: 1, time: Date(), isTaken: true)]
        reminderOption = reminderOptions[0]
        fetchMedications()
        
        
        
    }
    
    func fetchMedications() {
        medications = DatabaseHelper.shared.fetchMedications()
        print(medications)
    }
    
    func addMedication(medicineName: String, reminderTime: [Date], isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String? ) {
        DatabaseHelper.shared.addMedication(medicineName: medicineName, reminderTime: reminderTime, isDosedTracking: isDosedTracking, numberOfTablets: numberOfTablets, reminderOption: reminderOption)
        
        print("number of medicine \(isDosedTracking)")
        fetchMedications()
    }
    
    func updateMedication(medicineName: String, reminderTime: [ReminderTime], id: Int) {
        DatabaseHelper.shared.updateMedication(id: id, newMedicineName: medicineName, newReminderTime: reminderTime)
        fetchMedications()
        
    }
    
    func updateIsTaken(id: Int, reminderTimeID: Int,newIsTaken: Bool ){
        DatabaseHelper.shared.updateMedicationIsTaken(id: id, reminderTimeID: reminderTimeID, newIsTaken: newIsTaken)
        fetchMedications()
    }
}
    

