//
//  HistoryDataPreparer.swift
//  MedWise
//
//  Created by Anup Saud on 2023-12-11.
//

import Foundation

struct HistoryDataPreparer {
    static func prepareDataForSharing(groupedHistory: [[String: Any]]) -> String {
        var shareText = "Medication Intake Logs\n"
        for entry in groupedHistory {
            if let date = entry["date"] as? String,
               let historyEntries = entry["history"] as? [[String: Any]] {
                shareText += "\nDate: \(date)\n"
                for historyEntry in historyEntries {
                    if let medicineName = historyEntry["medicineName"] as? String,
                       let takenDate = historyEntry["takenDate"] as? Date,
                       let isTaken = historyEntry["isTaken"] as? Bool {
                        let status = isTaken ? "Taken" : "Skipped"
                        shareText += "\(medicineName) - \(takenDate.formatted()): \(status)\n"
                    }
                }
            }
        }
        return shareText
    }
}
