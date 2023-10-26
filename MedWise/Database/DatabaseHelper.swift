//
//  DatabaseHelper.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import Foundation

import SQLite

class DatabaseHelper {
    static let shared = DatabaseHelper()

    private let db: Connection?
    private let users = Table("users")
    private let medication = Table("medication")

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
                table.column(Expression<String>("sex"))
                table.column(Expression<Double>("height"))
                table.column(Expression<Double>("weight"))
                table.column(Expression<String>("medicineName"))
                table.column(Expression<Blob>("remainderTime"))
                
            })
            try db!.run(medication.create(ifNotExists: true) { table in
                table.column(Expression<Int>("id"), primaryKey: .autoincrement)
                table.column(Expression<String>("medicineName"))
                table.column(Expression<Blob>("reminderTime"))
                table.column(Expression<Bool>("isDosedTracking"), defaultValue: false)
                table.column(Expression<Int?>("numberOfTablets"))
                table.column(Expression<String?>("reminderOption"))
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func addUser(name: String, sex: String, height: Double, weight: Double) {
           // Implement the code for adding a user to the 'users' table
       }

    func addMedication(
        medicineName: String,
        reminderTime: [Date],
        isDosedTracking: Bool,
        numberOfTablets: Int?,
        reminderOption: String?
    ) {
        do {
            try db?.transaction {
                var reminderTimeData: [[String: Any]] = []

                for (index, date) in reminderTime.enumerated() {
                    let dateData: [String: Any] = [
                        "time": date,
                        "isTaken": false,
                        "id": index + 1
                    ]
                    reminderTimeData.append(dateData)
                }

                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeData, requiringSecureCoding: false)

                let insert = self.medication.insert(
                    Expression<String>("medicineName") <- medicineName,
                    Expression<Data?>("reminderTime") <- encodedData,
                    Expression<Bool>("isDosedTracking") <- isDosedTracking,
                    Expression<Int?>("numberOfTablets") <- numberOfTablets ?? 0,
                    Expression<String?>("reminderOption") <- reminderOption ?? ""
                )

                try db?.run(insert)
            }
        } catch {
            print("Unable to add medication: \(error)")
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
                   let reminderOption = row[Expression<String?>("reminderOption")] {

                    if let reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(reminderTimeData) as? [[String: Any]] {
                        var reminderTimes: [ReminderTime] = []

                        for reminderTimeInfo in reminderTimeArray {
                            if let time = reminderTimeInfo["time"] as? Date,
                               let id = reminderTimeInfo["id"] as? Int,
                               let isTaken = reminderTimeInfo["isTaken"] as? Bool {
                                let reminderTime = ReminderTime(id: id, time: time, isTaken: isTaken)
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
                            reminderOption: reminderOption
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

    
    func updateMedication(id: Int, newMedicineName: String, newReminderTime: [ReminderTime], isDosedTracking: Bool, numberOfTablets: Int?, reminderOption: String?) {
        do {
            try db?.transaction {
                // Convert the reminderTime array to a format suitable for storage
                var reminderTimeData: [[String: Any]] = []
                for (index, reminderTime) in newReminderTime.enumerated() {
                    let dateData: [String: Any] = [
                        "time": reminderTime.time,
                        "isTaken": reminderTime.isTaken,
                        "id": index + 1
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
//                   let existingReminderTimeData = existingMedication[Expression<Data?>("reminderTime")] {
//                    if var reminderTimeArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(existingReminderTimeData) as? [[String: Any]] {
//                        // Update the 'isTaken' property for the specific reminder time
//                        if let index = reminderTimeArray.firstIndex(where: { $0["id"] as? Int == reminderTimeID }) {
//                            reminderTimeArray[index]["isTaken"] = newIsTaken
//                        }
//
//                        // Encode the updated reminderTimeArray
//                        let updatedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)
//
//                        // Update the medication with the new reminderTime data
//                        let update = self.medication.filter(Expression<Int>("id") == id)
//                            .update(Expression<Data?>("reminderTime") <- updatedData)
//
//                        try db?.run(update)
//                    }
//                }
//            }
//        } catch {
//            print("Unable to update medication's isTaken property: \(error)")
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
                    }

                    // Decrement 'numberOfTablets' if 'isDosedTracking' is true
                    if isDosedTracking && numberOfTablets != nil {
                        numberOfTablets -= 1
                    }

                    // Encode the updated data
                    existingReminderTimeData = try NSKeyedArchiver.archivedData(withRootObject: reminderTimeArray, requiringSecureCoding: false)

                    // Update the medication with the new data
                    let update = self.medication.filter(Expression<Int>("id") == id)
                        .update(
                            Expression<Data?>("reminderTime") <- existingReminderTimeData,
                            Expression<Int?>("numberOfTablets") <- numberOfTablets
                        )

                    try db?.run(update)
                } else {
                     print("Error while updating medication's isTaken property")
                }
            }
        } catch {
            print("Error while updating medication's isTaken property: \(error)")
        }
    }



//    func deleteTimeTaken(mainId: Int, reminderTimeId: Int) {
//        do {
//            try db?.transaction {
//                // Create a delete statement
//                let delete = self.medication
//                    .filter(Expression<Int>("id") == mainId)
//                    .filter(Expression<Int>("reminderTime.id") == reminderTimeId)
//                    .delete()
//
//                try db?.run(delete)
//            }
//        } catch {
//            print("Unable to delete time taken: \(error)")
//        }
//    }
//
    
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


}
