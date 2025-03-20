//
//  Double+Casting.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import Foundation

public extension Double {
    /// Convert to CGFloat type
    var float: CGFloat { return CGFloat(self) }

    /// Convert to TimeInterval type
    var timeInterval: TimeInterval { return self as TimeInterval }

    /// Convert to String type
    var string: String { return String(self) }

    func toInt() -> Int? {
        if self >= Double(Int.min), self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
