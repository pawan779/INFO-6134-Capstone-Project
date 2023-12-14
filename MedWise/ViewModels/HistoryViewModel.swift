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
    
    
    // Gesture : Shake tips array
    let healthTips = [
        "Prioritize quality sleep for optimal physical and mental health.",
        "Incorporate omega-3 fatty acids into your diet for brain and heart health.",
        "Practice mindfulness meditation to reduce stress and improve focus.",
        "Engage in regular aerobic exercise to support cardiovascular health.",
        "Include a variety of colorful vegetables in your meals for diverse nutrient intake.",
        "Consume probiotics for a healthy gut microbiome and improved digestion.",
        "Stay hydrated by drinking an adequate amount of water throughout the day.",
        "Limit processed foods and choose whole, nutrient-dense options.",
        "Consider incorporating intermittent fasting for metabolic health benefits.",
        "Get regular check-ups and screenings to detect health issues early.",
        "Maintain a healthy weight through a balanced diet and regular exercise.",
        "Include strength training in your fitness routine to build and maintain muscle mass.",
        "Practice good posture to prevent musculoskeletal issues and back pain.",
        "Limit added sugars in your diet to reduce the risk of chronic diseases.",
        "Take breaks from screen time to protect your eyes and reduce digital eye strain.",
        "Stay socially connected to support mental and emotional well-being.",
        "Consider personalized genetic testing for insights into your health risks.",
        "Optimize vitamin D levels through sun exposure or supplements for bone health.",
        "Stay informed about the latest advancements in health and wellness research.",
        "Consult with healthcare professionals for personalized health advice and plans."
    ]

    
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
