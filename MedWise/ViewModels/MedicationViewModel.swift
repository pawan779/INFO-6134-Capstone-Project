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
    
    @Published var searchTerm: String = ""
    @Published var searchedResult : [Medication] = []
    
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
    @Published var selectedNotificationID: String = "nil"
    @Published var notificationTime: Date = Date()
    

    @Published var isFilterSheetPresented:Bool = false
    @Published var selectedFilterData: String = ""
    @Published var filteredData: [Medication] = []
    @Published var minFilterVal: Int = 0
    @Published var maxFilterVal: Int = 0
    
    var listData: [Medication] {
        return selectedFilterData.isEmpty ? (searchTerm.isEmpty ? medications : searchedResult) : filteredData
    }
    
    func toggleAddMedication(){
        isPresented.toggle()
        
    }
    
    
    internal init() {
        dataToBeUpdate = [ReminderTime(id: 1, time: Date(), isTaken: true, notificationID: "nil")]
        reminderOption = reminderOptions[0]
        fetchMedications()
        checkAndUpdateMedicationStatus()
      
    }
    
    func fetchMedications() {
        medications = DatabaseHelper.shared.fetchMedications()
        if (!searchTerm.isEmpty){
            filterSearchResults()
        }
        
        if(!selectedFilterData.isEmpty){
            filterMedication(minVal: minFilterVal, maxVal: maxFilterVal)
        }
        print(medications)
    }
    
    func addMedication(medicineName: String, reminderTime: [Date], isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String? ) {
        let generatedNotificationId = generateNotificationIdentifier(medicineName: medicineName)
        DatabaseHelper.shared.addMedication(medicineName: medicineName, reminderTime: reminderTime, isDosedTracking: isDosedTracking, numberOfTablets: numberOfTablets, reminderOption: reminderOption, notificationID: generatedNotificationId )
        
        print("number of medicine \(isDosedTracking)")
        scheduleNotifiction(reminderTime: reminderTime, medicineName: medicineName, notificationId: generatedNotificationId)
        fetchMedications()
    }
    
    func generateNotificationIdentifier(medicineName: String) -> String {
        return "\(Date())-\(medicineName)"
    }

    func scheduleNotifiction(reminderTime: [Date], medicineName: String, notificationId: String){
        
        for (index, date) in reminderTime.enumerated(){
            NotificationViewModel().scheduleDailyNotification(medicineName: medicineName, time: date, notificationID: notificationId + "\(index+1)")
        }
        
    }
    
    func updateMedication(medicineName: String, reminderTime: [ReminderTime], id: Int,isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String?, notificationID: String, notificationTime: Date  ) {
        DatabaseHelper.shared.updateMedication(id: id, newMedicineName: medicineName, newReminderTime: reminderTime, isDosedTracking: isDosedTracking, numberOfTablets: numberOfTablets, reminderOption: reminderOption)
        
        NotificationViewModel().cancelNotifications(notificationID: notificationID )
        NotificationViewModel().scheduleDailyNotification(medicineName: medicineName, time: notificationTime, notificationID: notificationID)
        fetchMedications()
        
    }
    
    func updateIsTaken(id: Int, reminderTimeID: Int,newIsTaken: Bool ){
        DatabaseHelper.shared.updateMedicationIsTaken(id: id, reminderTimeID: reminderTimeID, newIsTaken: newIsTaken)
        fetchMedications()
    }
    
    func deleteMedication(mainId: Int, reminderTimeId: Int, notificationID: String){
        DatabaseHelper.shared.deleteReminderTime(medicationId: mainId, reminderTimeId: reminderTimeId)
        NotificationViewModel().cancelNotifications(notificationID: notificationID)
        fetchMedications()
    }
    
    func checkAndUpdateMedicationStatus() {
        
        guard let firstMedication = medications.first else {
            return
        }
        
        let currentDate = Date()
        
        if !Calendar.current.isDate(firstMedication.medicationDate, inSameDayAs: currentDate) {
            print("Reset medication")
            DatabaseHelper.shared.resetAllMedicationIsTaken()
            fetchMedications()
        }
    }
    
    func filterSearchResults() {
        selectedFilterData = ""
        searchedResult = medications.filter({$0.medicineName.localizedCaseInsensitiveContains(searchTerm)}
        )
    }
    
    func filterMedication(minVal: Int, maxVal: Int ){
        isFilterSheetPresented = false
        let dataToBeSearched = !searchTerm.isEmpty ? searchedResult : medications
        filteredData = dataToBeSearched.filter { medication in
                if let numberOfTablets = medication.numberOfTablets {
//                    return numberOfTablets > 5
                    
                    if (minVal != 0 && maxVal != 0){
                        return numberOfTablets >= minVal && numberOfTablets <= maxVal
                    }
                    else if (maxVal != 0 && minVal == 0){
                        return numberOfTablets > maxVal
                    }
                    else{
                        return numberOfTablets < minVal && medication.isDosedTracking
                    }
                  
                }
                return false
            }
    }
}
    


