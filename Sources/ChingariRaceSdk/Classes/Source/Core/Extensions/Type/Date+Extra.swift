//
//  Date+Extra.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation

public extension Date {
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }

    func wasYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}
