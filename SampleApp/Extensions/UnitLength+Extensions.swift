//
//  UnitLength.swift
//  Sample App
//
//  Created by Mudassir Asghar on 24/05/2024.
//

import Foundation
extension UnitLength {
    static var preciseMiles: UnitLength {
        return UnitLength(symbol: "mile",
                          converter: UnitConverterLinear(coefficient: 1609.344))
    }
}
