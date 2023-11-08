//
//  HelperFunction.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/22/23.
//

import Foundation


class HelperFunction{
    
    func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: time)
    }
    
    func formattedHour(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        return formatter.string(from: time)
    }
    
    func formattedMinutes(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: time)
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
