//
//  HistoryViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 11/23/23.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var groupedHistory: [[String: Any]] = []
    @Published var history: [[String: Any]] = []
    @Published var skippedData: [[String: Any]] = []
    private var databaseHelper = DatabaseHelper.shared
    @Published var showSkippedMedicines: Bool = false
    
    init(){
        fetchHistoryGroupedByDate()

    }
    
    func fetchHistoryGroupedByDate() {
        let historyData = databaseHelper.fetchHistoryGroupedByDate()
        self.groupedHistory = historyData
        showData()
    
    }
    
    func showData(){
        filterSkippedData()
        history = showSkippedMedicines ? skippedData : groupedHistory

    }

    
    func toggleShowSkippedMedicines() {
          showSkippedMedicines.toggle()
        showData()
        
      }
    
    func filterSkippedData(){
        let filteredData = groupedHistory.map { (entry: [String: Any]) -> [String: Any] in
            guard var history = entry["history"] as? [[String: Any]] else { return entry }
            history = history.filter { historyEntry in
                return historyEntry["isTaken"] as? Bool == false
            }
            var filteredEntry = entry
            filteredEntry["history"] = history
           return filteredEntry
        }
        self.skippedData = filteredData
    }
}






