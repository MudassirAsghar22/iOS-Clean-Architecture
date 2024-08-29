//
//  Double+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 22/05/2024.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor

    }

    func roundedString(toPlaces places: Int) -> String {
        let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2

//        return String(format: "%.2%", formatter.string(from: NSNumber(value: self))!)
        return formatter.string(from: NSNumber(value: self))!

    }

}
