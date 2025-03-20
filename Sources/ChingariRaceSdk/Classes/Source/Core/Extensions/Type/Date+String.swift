//
//  Date+String.swift
//  chingari
//
//  Created by Тетяна Нєізвєстна on 24.11.2021.
//  Copyright © 2021 Nikola Milic. All rights reserved.
//

import Foundation

public extension Date {
    enum Format: String {
        case json = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case dayAndMonth = "dd MMM"
        case ddMMyyyy = "dd/MM/yyyy"
        case hmmssa = "h:mm:ss a"
        case MMMddyyyyhmmssa = "MMM dd, yyyy h:mm:ss a"
        case MMMddyyyy = "MMM dd, yyyy"
        case yyyymmddhhmmss = "yyyy-mm-dd hh:mm:ss"
        case ddMMyyHHmm = "dd-MM-yy HH:mm"
        case ddMMyy = "dd-MM-yy"
        case transactionDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z"
        case dayMonthYear = "dd MMM yyyy"
        case yyyyMMDD = "YYYY-MM-DD"
        case yyyyMMdd = "yyyy-MM-dd"
        case MMMMyyyy = "MMMM yyyy"
        case hhmmss = "HH:mm:ss"
    }
    
    func getDayAndMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Format.dayAndMonth.rawValue
        return formatter.string(from: self)
    }
    
    func getString(format: Date.Format, locale: Locale? = nil) -> String {
        let dateFormatter = DateFormatter()
        if let locale {
            dateFormatter.locale = locale
        }
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func localizedString(relativeTo date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: date)
    }
}

public extension String {
    func dateFromString(format: Date.Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}

public enum TransactionDateFormat {
    case today(String)
    case yesterday(String)
    case anyDay(String)
    case noDate
}

public extension String {
    func transactionDateFormat() -> TransactionDateFormat {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z"
        
        guard let date = inputFormatter.date(from: self) else {
            return .noDate
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        if date.isToday() {
            outputFormatter.dateFormat = "h:mm a"
            return .today(outputFormatter.string(from: date))
        } else if date.wasYesterday() {
            outputFormatter.dateFormat = "h:mm a"
            return .yesterday(outputFormatter.string(from: date))
        } else {
            outputFormatter.dateFormat = "MMM dd, yyyy h:mm a"
            return .anyDay(outputFormatter.string(from: date))
        }
    }
}

public extension Date {
    static func getFurtureDate(days:Int) -> Date? {
        var components = DateComponents()
        components.setValue(days, for: .day)
        let furtureDate = Calendar.current.date(byAdding: components, to: Date())
        return furtureDate
    }
}
