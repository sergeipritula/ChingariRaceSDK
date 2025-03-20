//
//  Float+Casting.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import Foundation

public extension Float {
    /// Convert to Double type
    var double: Double { return Double(self) }

    /// Convert to CGFloat type
    var float: CGFloat { return CGFloat(self) }

    /// Convert to Int type
    var int: Int { return Int(self) }

    /// Convert to TimeInterval type
    var timeInterval: TimeInterval { return TimeInterval(self) }

    /// Convert to String type
    var stringValue: String { return String(self) }
    
    /// Remove decimal if zero
    var clean: String {
        self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
