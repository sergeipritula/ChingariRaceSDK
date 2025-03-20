//
//  Range+ext.swift
//  Extensions
//
//  Created by Slava Leschenko on 25.01.2023.
//

import Foundation

public extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
