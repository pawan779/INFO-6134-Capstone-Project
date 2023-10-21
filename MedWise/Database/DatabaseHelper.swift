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
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }

    
}
