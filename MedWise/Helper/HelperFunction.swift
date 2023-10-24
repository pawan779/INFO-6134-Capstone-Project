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
}
