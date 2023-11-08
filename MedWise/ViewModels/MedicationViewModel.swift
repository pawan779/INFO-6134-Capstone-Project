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


    @Published var isFilterSheetPresented: Bool = false
    @Published var selectedFilterData: String = ""
    @Published var filteredData: [Medication] = []
    @Published var minFilterVal: Int = 0
    @Published var maxFilterVal: Int = 0
    @Published var sortedData: [Medication] = []
    @Published var selectedSortedValue: String = ""

    var listData: [Medication] {
//        return selectedFilterData.isEmpty ? (searchTerm.isEmpty ? medications : searchedResult) : filteredData

        if(!selectedFilterData.isEmpty){
            return filteredData
        }
        else if (!selectedSortedValue.isEmpty){
            return sortedData
        }
        else if (!searchTerm.isEmpty){
            return searchedResult
        }
        else{
            return medications
        }
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
    
    func clear(){
        medicineName = ""
        selectedFrequency = 1
        dataToBeUpdate = [ReminderTime(id: 1, time: Date(), isTaken: true, notificationID: "nil")]
        reminderOption = reminderOptions[0]
        searchTerm = ""
        selectedFilterData = ""
        selectedSortedValue = ""
        numberOfTablets = 1
    }

    func fetchMedications() {
        medications = DatabaseHelper.shared.fetchMedications()
        if (!searchTerm.isEmpty){
            filterSearchResults()
        }

        if(!selectedFilterData.isEmpty){
            filterMedication(minVal: minFilterVal, maxVal: maxFilterVal)
        }

        if(!selectedSortedValue.isEmpty){
            sortMedication(filterMode: selectedSortedValue)
        }
    }

    func addMedication(medicineName: String, reminderTime: [Date], isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String? ) {
        let generatedNotificationId = generateNotificationIdentifier(medicineName: medicineName)
        DatabaseHelper.shared.addMedication(medicineName: medicineName, reminderTime: reminderTime, isDosedTracking: isDosedTracking, numberOfTablets: numberOfTablets, reminderOption: reminderOption, notificationID: generatedNotificationId )
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
        DatabaseHelper.shared.updateMedication(id: id, newMedicineName: medicineName, newReminderTime: reminderTime, isDosedTracking: isDosedTracking, numberOfTablets: numberOfTablets, reminderOption: reminderOption, notificationID: notificationID)

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
        selectedSortedValue = ""
        searchedResult = medications.filter({$0.medicineName.localizedCaseInsensitiveContains(searchTerm)}
        )
    }



    func filterMedication(minVal: Int, maxVal: Int ){
        selectedSortedValue = ""
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

    func sortMedication(filterMode: String) {
        selectedFilterData = ""
        isFilterSheetPresented = false
        func isTimeInRange(date: Date, filterMode: String) -> Bool {
            let calendar = Calendar.current
            switch filterMode {
            case "Morning":
                return calendar.component(.hour, from: date) >= 0 && calendar.component(.hour, from: date) < 12
            case "Day":
                return calendar.component(.hour, from: date) >= 12 && calendar.component(.hour, from: date) < 18
            case "Evening":
                return calendar.component(.hour, from: date) >= 18
            default:
                return false
            }
        }


        sortedData = medications.map { medication in
            let filteredReminderTime = medication.reminderTime.filter { reminderTime in
                return isTimeInRange(date: reminderTime.time, filterMode: filterMode)
            }


            if !filteredReminderTime.isEmpty {
                return Medication(
                    id: medication.id,
                    medicineName: medication.medicineName,
                    reminderTime: filteredReminderTime,
                    isDosedTracking: medication.isDosedTracking,
                    numberOfTablets: medication.numberOfTablets,
                    reminderOption: medication.reminderOption,
                    medicationDate: medication.medicationDate
                )
            }

            return nil
        }.compactMap { $0 }
    }

}
