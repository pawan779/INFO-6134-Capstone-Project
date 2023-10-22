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
                      })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func addUser(name: String, sex: String, height: Double, weight: Double) {
           // Implement the code for adding a user to the 'users' table
       }

       func addMedication(medicineName: String, reminderTime: [Date]) {
           do {
               let encodedData = try NSKeyedArchiver.archivedData(withRootObject: reminderTime, requiringSecureCoding: false)

               let insert = self.medication.insert(
                   Expression<String>("medicineName") <- medicineName,
                   Expression<Data?>("reminderTime") <- encodedData
               )

               try db?.run(insert)
           } catch {
               print("Unable to add medication: \(error)")
           }
       }
    
    func fetchMedications() -> [Medication] {
        var medications: [Medication] = []

        do {
            for medicationRow in try db!.prepare(medication) {
                let medicineName = medicationRow[Expression<String>("medicineName")]
                
                if let data = medicationRow[Expression<Data?>("reminderTime")] {
                    if let reminderTime = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Date] {
                        let medication = Medication(id: medicationRow[Expression<Int>("id")], medicineName: medicineName, reminderTime: reminderTime)
                        medications.append(medication)
                    }
                }
            }
        } catch {
            print("Unable to fetch medication data: \(error)")
        }

        return medications
    }

    
}
