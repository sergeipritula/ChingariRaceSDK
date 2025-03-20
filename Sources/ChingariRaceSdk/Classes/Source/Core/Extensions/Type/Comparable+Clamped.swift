//
//  Comparable+Clamped.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 07.06.2021.
//

import Foundation

public extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
