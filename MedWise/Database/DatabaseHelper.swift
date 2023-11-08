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
                table.column(Expression<Bool>("isDosedTracking"), defaultValue: false)
                table.column(Expression<Int?>("numberOfTablets"))
                table.column(Expression<String?>("reminderOption"))
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
    
    
    
//    func getUser() -> User? {
//        do {
//            if let row = try db?.pluck(users) {
//                let id = row[Expression<Int>("id")]
//                let name = row[Expression<String>("name")]
//                let email = row[Expression<String?>("email")]
//                let phone = row[Expression<String?>("phone")]
//                let gender = row[Expression<String>("gender")]
//                let age = row[Expression<String>("age")]
//                let weight = row[Expression<String>("weight")]
//
//                return User(id: id, name: name, email: email, phone: phone, gender: gender, age: age, weight: weight)
//            }
//        } catch {
//            print("Unable to fetch user: \(error)")
//        }
//
//        return nil
//    }

    
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

    func updateMedication(id: Int, newMedicineName: String, newReminderTime: [ReminderTime]) {
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
                        Expression<Data?>("reminderTime") <- encodedData
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




}
