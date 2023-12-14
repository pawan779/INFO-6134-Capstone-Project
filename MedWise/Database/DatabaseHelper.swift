//
//  DatabaseHelper.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation

import SQLite

import CoreData

class DatabaseHelper {
    static let shared = DatabaseHelper()

    private let db: Connection?
    private let users = Table("users")
    private let medication = Table("medication")
    private let appointments = Table("appointments")
    private let history = Table("history")
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            db = nil
            print("Unable to open database")
        }
    }

    func createTableIfNotExists() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(Expression<Int>("id"), primaryKey: .autoincrement)
                table.column(Expression<String>("name"))
                table.column(Expression<String>("email"))
                table.column(Expression<String>("phone"))
                table.column(Expression<String>("gender"))
                table.column(Expression<String>("age"))
                table.column(Expression<String>("weight"))
//                table.column(Expression<String>("medicineName"))
//                table.column(Expression<Blob>("remainderTime"))

            })
            try db!.run(medication.create(ifNotExists: true) { table in
                table.column(Expression<Int>("id"), primaryKey: .autoincrement)
                table.column(Expression<String>("medicineName"))
                table.column(Expression<Blob>("reminderTime"))
                table.column(Expression<Date>("medicationDate"))
                table.column(Expression<Bool>("isDosedTracking"), defaultValue: false)
                table.column(Expression<Int?>("numberOfTablets"))
                table.column(Expression<String?>("reminderOption"))
            })
            //appointment
                   try db!.run(appointments.create(ifNotExists: true) { table in
                       table.column(Expression<String>("id"), primaryKey: true)
                       table.column(Expression<String>("doctorName"))
                       table.column(Expression<String>("reason"))
                       table.column(Expression<String>("contactNumber"))
                       table.column(Expression<Date>("date"))
                       table.column(Expression<Date>("time"))
                   })
            
            try db!.run(history.create(ifNotExists: true) { table in
                table.column(Expression<UUID>("id"), primaryKey: true)
                table.column(Expression<Int>("medicineId"))
                table.column(Expression<Int>("reminderTimeId"))
                table.column(Expression<String>("medicineName"))
                table.column(Expression<Date>("takenDate"))
                table.column(Expression<Bool>("isTaken"))
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }

    func addUser(
        name: String,
        email : String?,
        phone : String?,
        gender: String,
        age: String,
        weight: String
        )
    {
        do {
            let insert = self.users.insert(
                Expression<String>("name") <- name,
                Expression<String?>("email") <- email ?? "" ,
                Expression<String?>("phone") <- phone ?? "",
                Expression<String>("gender") <- gender,
                Expression<String>("age") <- age,
                Expression<String>("weight") <- weight
            )
            try db?.run(insert)
            print("User table added",insert)
        } catch {
            print("Unable to add user: \(error)")
        }
    }

    func updateUserProfile(id: Int, name: String, email: String?, phone: String?, gender: String, age: String, weight: String) {
        do {
            let user = self.users.filter(Expression<Int>("id") == id)
            let update = user.update(
                Expression<String>("name") <- name,
                Expression<String?>("email") <- email,
                Expression<String?>("phone") <- phone,
                Expression<String>("gender") <- gender,
                Expression<String>("age") <- age,
                Expression<String>("weight") <- weight
            )
            if try db?.run(update) ?? 1 > 0 {
                print("User profile updated successfully")
            } else {
                print("No user found with the provided ID")
            }
        } catch {
            print("Unable to update user profile: \(error)")
        }
    }

    func deleteUser(id: Int) {
        do {
            let userToDelete = users.filter(Expression<Int>("id") == id)
            try db?.run(userToDelete.delete())
        } catch {
            print("Unable to delete user: \(error)")
        }
    }


    // worked
    func getUser() -> User? {
        do {
            // GET LASTEST USER data
            let query = users.order(Expression<Int>("id").desc).limit(1) // Order by ID in descending order and limit to 1 result
            if let row = try db?.pluck(query) {
                let id = row[Expression<Int>("id")]
                let name = row[Expression<String>("name")]
                let email = row[Expression<String?>("email")]
                let phone = row[Expression<String?>("phone")]
                let gender = row[Expression<String>("gender")]
                let age = row[Expression<String>("age")]
                let weight = row[Expression<String>("weight")]
                

                return User(id: id, name: name, email: email, phone: phone, gender: gender, age: age, weight: weight)
            }
        } catch {
            print("Unable to fetch last user: \(error)")
        }
        return nil
    }



    func addMedication(
        medicineName: String,
        reminderTime: [Date],
        isDosedTracking: Bool,
        numberOfTablets: Int?,
        reminderOption: String?,
        notificationID: String
    ) {
        do {
            try db?.transaction {
                var reminderTimeData: [[String: Any]] = []

                for (index, date) in reminderTime.enumerated() {
                    let dateData: [String: Any] = [
                        "time": date,
                        "isTaken": false,
                        "id": index + 1,
                        "notificationID": notificationID + "\(index+1)",
                        "takenDate": Date(),
                        "isSkipped": false
                    ]
                    reminderTimeData.append(dateData)
                }

                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeData, requiringSecureCoding: false)

                let insert = self.medication.insert(
                    Expression<String>("medicineName") <- medicineName,
                    Expression<Data?>("reminderTime") <- encodedData,
                    Expression<Bool>("isDosedTracking") <- isDosedTracking,
                    Expression<Int?>("numberOfTablets") <- numberOfTablets ?? 0,
                    Expression<String?>("reminderOption") <- reminderOption ?? "",
                    Expression<Date>("medicationDate") <- Date()
                )
                
           

                try db?.run(insert)
            }
        } catch {
            print("Unable to add medication: \(error)")
        }
    }

    
    func deleteUserProfile() {
        do {
            let delete = users.delete()
            try db?.run(delete)
        } catch {
            print("Unable to delete user: \(error)")
        }
    }
    
    func deleteAllMedications() {
        do {
            let delete = medication.delete()
            try db?.run(delete)
        } catch {
            print("Unable to delete medications: \(error)")
        }
    }
    
    func fetchMedications() -> [Medication] {
        var medications: [Medication] = []

        do {
            for row in try db!.prepare(medication) {
                
              
                if let medicineName = row[Expression<String?>("medicineName")],
                   let reminderTimeData = row[Expression<Data?>("reminderTime")],
                   let isDosedTracking = row[Expression<Bool?>("isDosedTracking")],
                   let numberOfTablets = row[Expression<Int?>("numberOfTablets")],
                   let medicationDate = row[Expression<Date?>("medicationDate")],
                   let reminderOption = row[Expression<String?>("reminderOption")] {

               
                    
                    if let reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reminderTimeData) as? [[String: Any]] {
                        var reminderTimes: [ReminderTime] = []

                        for reminderTimeInfo in reminderTimeArray {

                            if let time = reminderTimeInfo["time"] as? Date,
                               let id = reminderTimeInfo["id"] as? Int,
                               let notificationID = reminderTimeInfo["notificationID"] as? String,
                               let takenDate = reminderTimeInfo["takenDate"] as? Date,
                               let isSkipped = reminderTimeInfo["isSkipped"] as? Bool,
                               let isTaken = reminderTimeInfo["isTaken"] as? Bool {
                                let reminderTime = ReminderTime(id: id, time: time, isTaken: isTaken, notificationID: notificationID, takenDate: takenDate, isSkipped: isSkipped)
                                reminderTimes.append(reminderTime)
                            }
                        }

                        let actualID = row[Expression<Int>("id")]
                        let medication = Medication(
                            id: actualID,
                            medicineName: medicineName,
                            reminderTime: reminderTimes,
                            isDosedTracking: isDosedTracking,
                            numberOfTablets: numberOfTablets,
                            reminderOption: reminderOption,
                            medicationDate: medicationDate
                        )
                        medications.append(medication)
                    }
                }
            }
        } catch {
            print("Unable to fetch medications: \(error)")
        }


        return medications
    }

    
    func updateMedication(id: Int, newMedicineName: String, newReminderTime: [ReminderTime], isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String?, notificationID: String) {
        do {
            try db?.transaction {
                // Convert the reminderTime array to a format suitable for storage
                var reminderTimeData: [[String: Any]] = []
                for (index, reminderTime) in newReminderTime.enumerated() {
                    let dateData: [String: Any] = [
                        "time": reminderTime.time,
                        "isTaken": reminderTime.isTaken,
                        "id": index + 1,
                        "notificationID": notificationID
                    ]
                    reminderTimeData.append(dateData)
                }

                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeData, requiringSecureCoding: false)

                // Create an update statement
                let update = self.medication.filter(Expression<Int>("id") == id)
                    .update(
                        Expression<String>("medicineName") <- newMedicineName,
                        Expression<Data?>("reminderTime") <- encodedData,
                        Expression<Bool>("isDosedTracking") <- isDosedTracking,
                        Expression<Int?>("numberOfTablets") <- numberOfTablets,
                        Expression<String?>("reminderOption") <- reminderOption
                    )

                try db?.run(update)
            }
        } catch {
            print("Unable to update medication: \(error)")
        }
    }

    



//    func updateMedicationIsTaken(id: Int, reminderTimeID: Int, newIsTaken: Bool) {
//        do {
//            try db?.transaction {
//                // Retrieve the existing medication
//                if let existingMedication = try db?.pluck(medication.filter(Expression<Int>("id") == id)),
//                   var existingReminderTimeData = existingMedication[Expression<Data?>("reminderTime")],
//                   let isDosedTracking = existingMedication[Expression<Bool?>("isDosedTracking")],
//                   var numberOfTablets = existingMedication[Expression<Int?>("numberOfTablets")],
//                   var reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(existingReminderTimeData) as? [[String: Any]] {
//                    
//                    // Update the 'isTaken' property for the specific reminder time
//                    if let index = reminderTimeArray.firstIndex(where: { $0["id"] as? Int == reminderTimeID }) {
//                        reminderTimeArray[index]["isTaken"] = newIsTaken
//                        reminderTimeArray[index]["takenDate"] = Date()
//                    }
//
//                    // Decrement 'numberOfTablets' if 'isDosedTracking' is true
//                    if isDosedTracking && numberOfTablets != nil {
//                        numberOfTablets -= 1
//                    }
//
//                    // Encode the updated data
//                    existingReminderTimeData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)
//
//                    // Update the medication with the new data
//                    let update = self.medication.filter(Expression<Int>("id") == id)
//                        .update(
//                            Expression<Data?>("reminderTime") <- existingReminderTimeData,
//                            Expression<Int?>("numberOfTablets") <- numberOfTablets
//                        )
//
//                    try db?.run(update)
//                } else {
//                     print("Error while updating medication's isTaken property")
//                }
//            }
//        } catch {
//            print("Error while updating medication's isTaken property: \(error)")
//        }
//    }
    
    


    func updateMedicationIsTaken(id: Int, reminderTimeID: Int, newIsTaken: Bool) {
        do {
            try db?.transaction {
                // Retrieve the existing medication
                if let existingMedication = try db?.pluck(medication.filter(Expression<Int>("id") == id)),
                    var existingReminderTimeData = existingMedication[Expression<Data?>("reminderTime")],
                    let isDosedTracking = existingMedication[Expression<Bool?>("isDosedTracking")],
                    var numberOfTablets = existingMedication[Expression<Int?>("numberOfTablets")],
                    var reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(existingReminderTimeData) as? [[String: Any]] {

                    // Update the 'isTaken' property for the specific reminder time
                    if let index = reminderTimeArray.firstIndex(where: { $0["id"] as? Int == reminderTimeID }) {
                        reminderTimeArray[index]["isTaken"] = newIsTaken
                        reminderTimeArray[index]["isSkipped"] = !newIsTaken
                        reminderTimeArray[index]["takenDate"] = Date()
                    }

                    // Decrement 'numberOfTablets' if 'isDosedTracking' is true
                    if(newIsTaken == true){
                        if isDosedTracking && numberOfTablets != nil {
                            numberOfTablets -= 1
                        }}

                    // Encode the updated data
                    existingReminderTimeData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)

                    // Update the medication with the new data
                    let medicationUpdate = self.medication.filter(Expression<Int>("id") == id)
                        .update(
                            Expression<Data?>("reminderTime") <- existingReminderTimeData,
                            Expression<Int?>("numberOfTablets") <- numberOfTablets
                        )

                    try db?.run(medicationUpdate)
                    
                    
                    
                    let idColumn = Expression<UUID>("id")
                    let medicineIdColumn = Expression<Int>("medicineId")
                    let medicineNameColumn = Expression<String>("medicineName")
                    let reminderTimeIdColumn = Expression<Int>("reminderTimeId")
                    let takenDateColumn = Expression<Date>("takenDate")
                    let isTakenColumn = Expression<Bool>("isTaken")


                    // Add entry to the History table
                    let historyEntry = History(
                        id: UUID(),
                        medicineId: existingMedication[Expression<Int>("id")],
                        reminderTimeId: reminderTimeID,
                        medicineName: existingMedication[Expression<String>("medicineName")],
                        takenDate: Date(),
                        isTaken: newIsTaken
                    )
                    do {
                        let insert = try self.db?.run(history.insert(
                            idColumn <- historyEntry.id,
                            medicineIdColumn <- historyEntry.medicineId,
                            medicineNameColumn <- historyEntry.medicineName,
                            reminderTimeIdColumn <- historyEntry.reminderTimeId,
                            takenDateColumn <- historyEntry.takenDate,
                            isTakenColumn <- historyEntry.isTaken
                        ))
                        if insert == nil {
                            print("Error while inserting into History table")
                        }
                    } catch {
                        print("Error while inserting into History table: \(error)")
                    }
                } else {
                    print("Error while updating medication's isTaken property: Medication not found")
                }
            }
        } catch {
            print("Error while updating medication's isTaken property: \(error)")
        }
    }

        
    func fetchHistoryGroupedByDate() -> [[String: Any]] {
        let idColumn = Expression<UUID>("id")
        let medicineIdColumn = Expression<Int>("medicineId")
        let medicineNameColumn = Expression<String>("medicineName")
        let reminderTimeIdColumn = Expression<Int>("reminderTimeId")
        let takenDateColumn = Expression<Date>("takenDate")
        let isTakenColumn = Expression<Bool>("isTaken")
        
        do {
            // Fetch all entries from the History table ordered by takenDate (latest first)
            let historyEntries = try db?.prepare(history.order(takenDateColumn.desc))

            // Initialize a dictionary to group history entries by date
            var historyGroupedByDate: [String: [[String: Any]]] = [:]

            // Convert SQLite rows to dictionaries
            historyEntries?.forEach { row in
                let historyEntry: [String: Any] = [
                    "id": try? row.get(idColumn),
                    "medicineId": try? row.get(medicineIdColumn),
                    "medicineName": try? row.get(medicineNameColumn),
                    "reminderTimeId": try? row.get(reminderTimeIdColumn),
                    "takenDate": try? row.get(takenDateColumn),
                    "isTaken": try? row.get(isTakenColumn)
                ]

                // Extract the date string from the takenDate
                if let date = try? row.get(takenDateColumn) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"  // Adjust the date format as needed
                    let dateString = dateFormatter.string(from: date)

                    // Append the history entry to the corresponding date in the dictionary
                    if var historyArray = historyGroupedByDate[dateString] {
                        historyArray.append(historyEntry)
                        historyGroupedByDate[dateString] = historyArray
                    } else {
                        historyGroupedByDate[dateString] = [historyEntry]
                    }
                }
            }

            // Convert the dictionary to the final array format
            let resultArray = historyGroupedByDate.map { (date, historyArray) in
                return ["date": date, "history": historyArray]
            }

            return resultArray

        } catch {
            print("Error while fetching history: \(error)")
            return []
        }
    }


        
        
        
        
        func deleteReminderTime( medicationId: Int, reminderTimeId: Int) {
            do {
                try db?.transaction {
                    // Find the medication by its ID
                    let medicationFilter = self.medication.filter(Expression<Int>("id") == medicationId)
                    
                    // Fetch the existing reminder times for the medication
                    let medicationWithReminderTime = try db?.pluck(medicationFilter)
                    var reminderTimes = medicationWithReminderTime?[Expression<Data?>("reminderTime")]
                    
                    if var reminderTimeData = reminderTimes as? Data {
                        var reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reminderTimeData) as? [[String: Any]]
                        
                        // Filter the reminder times to exclude the one with the specified reminderTimeId
                        reminderTimeArray = reminderTimeArray?.filter { reminderTime in
                            guard let id = reminderTime["id"] as? Int else { return true }
                            return id != reminderTimeId
                        }
                        
                        // Encode the updated reminderTime array
                        let encodedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)
                        
                        // Update the medication with the modified reminder times
                        let update = medicationFilter.update(
                            Expression<Data?>("reminderTime") <- encodedData
                        )
                        
                        try db?.run(update)
                    }
                }
            } catch {
                print("Unable to delete reminder time: \(error)")
            }
        }
    


    
    
    func resetAllMedicationIsTaken() {
        do {
            try db?.transaction {
                // Fetch all medications from the database
                for medicationRow in try db!.prepare(medication) {
                    let id = medicationRow[Expression<Int>("id")]
                    if var reminderTimeData = medicationRow[Expression<Data?>("reminderTime")] {
                        // Decode the reminderTimeData into an array of dictionaries
                        guard var reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reminderTimeData) as? [[String: Any]] else {
                            continue // Skip this medication if the data cannot be decoded
                        }

                        // Reset the "isTaken" property for each reminder time
                        for reminderTimeIndex in 0..<reminderTimeArray.count {
                            reminderTimeArray[reminderTimeIndex]["isTaken"] = false
                        }

                        // Encode the updated data
                        reminderTimeData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)

                        // Create an update statement for reminderTime and medicationDate
                        let update = self.medication.filter(Expression<Int>("id") == id)
                            .update(
                                Expression<Data?>("reminderTime") <- reminderTimeData,
                                Expression<Date>("medicationDate") <- Date()
                            )

                        try db?.run(update)
                    }
                }
            }
        } catch {
            print("Unable to reset 'isTaken' property for all medications: \(error)")
        }
    }
    
    
    func replaceHistoryForYesterday(medications: [MedWise.Medication]) {
        let idColumn = Expression<UUID>("id")
        let medicineIdColumn = Expression<Int>("medicineId")
        let medicineNameColumn = Expression<String>("medicineName")
        let reminderTimeIdColumn = Expression<Int>("reminderTimeId")
        let takenDateColumn = Expression<Date>("takenDate")
        let isTakenColumn = Expression<Bool>("isTaken")
        do {
            try db?.transaction {
                let calendar = Calendar.current
                // Calculate yesterday's date
                let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()

                // Delete existing records for yesterday's date
                let delete = history.filter(Expression<Date>("takenDate") == yesterday)
                    .delete()

                try db?.run(delete)

                // Insert new records from the Medication table
                for medication in medications {
                    for reminderTime in medication.reminderTime {
                        let historyEntry = History(
                            id: UUID(),
                            medicineId: medication.id,
                            reminderTimeId: reminderTime.id,
                            medicineName: medication.medicineName,
                            takenDate: reminderTime.takenDate ?? Date(),
                            isTaken: reminderTime.isTaken
                        )

                        do {
                            let insert = try self.db?.run(history.insert(
                                idColumn <- historyEntry.id,
                                medicineIdColumn <- historyEntry.medicineId,
                                medicineNameColumn <- historyEntry.medicineName,
                                reminderTimeIdColumn <- historyEntry.reminderTimeId,
                                takenDateColumn <- historyEntry.takenDate,
                                isTakenColumn <- historyEntry.isTaken
                            ))
                            if insert == nil {
                                print("Error while inserting into History table")
                            }
                        } catch {
                            print("Error while inserting into History table: \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Error while replacing history: \(error)")
        }
    }


    
    
    // Fetch all appointments from the database
    func fetchAppointments() -> [Appointment] {
        var appointments: [Appointment] = []
        
        do {
            for appointment in try db!.prepare(self.appointments) {
                let id = UUID(uuidString: appointment[Expression<String>("id")]) ?? UUID()
                let doctorName = appointment[Expression<String>("doctorName")]
                let reason = appointment[Expression<String>("reason")]
                let contactNumber = appointment[Expression<String>("contactNumber")]
                let date = appointment[Expression<Date>("date")]
                let time = appointment[Expression<Date>("time")]
                
                appointments.append(Appointment(id: id, doctorName: doctorName, reason: reason, contactNumber: contactNumber, date: date, time: time))
            }
        } catch {
            print("Fetch failed: \(error)")
        }
        
        return appointments
    }
    
    // Insert a new appointment into the database
    func addAppointment(appointment: Appointment) {
        let insertQuery = appointments.insert(
            Expression<String>("id") <- appointment.id.uuidString,
            Expression<String>("doctorName") <- appointment.doctorName,
            Expression<String>("reason") <- appointment.reason,
            Expression<String>("contactNumber") <- appointment.contactNumber,
            Expression<Date>("date") <- appointment.date,
            Expression<Date>("time") <- appointment.time
        )
        
        do {
            try db!.run(insertQuery)
            print("Inserted appointment")
        } catch {
            print("Insertion failed: \(error)")
        }
    }
    
// Function to delete an appointment from the database
func deleteAppointment(appointmentId: UUID) {
    do {
        // Create a filter for the appointment to delete by matching the UUID string
        let query = appointments.filter(Expression<String>("id") == appointmentId.uuidString)
        // Attempt to run the delete command
        try db?.run(query.delete())
    } catch {
        print("Unable to delete appointment: \(error)")
    }
}
    
    //delete All Users
        func deleteAllAppointments() {
            do {
                try db?.run(appointments.delete())
            } catch {
                print("Unable to delete all appointments: \(error)")
            }
        }

    


}
