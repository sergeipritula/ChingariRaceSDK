//
//  Dictionary+Extensions.swift
//  Extensions
//
//  Created by Aleksandr Vdovichenko on 15.11.2022.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
    
    var trimmingEmptyValues: [String: Any] {
        var copy = self
        forEach { (key, value) in
            if let string = value as? String, string.isEmpty {
                copy.removeValue(forKey: key)
            } 
        }
        return copy
    }
}

extension Dictionary where Value: Any {
    func convertToSimpleStringDictionary() -> [String: String] {
        var convertedDictionary: [String: String] = [:]

        for (key, value) in self {
            if let stringValue = value as? String {
                convertedDictionary[String(describing: key)] = stringValue
            } else {
                let stringValue = String(describing: value)
                convertedDictionary[String(describing: key)] = stringValue
            }
        }
        return convertedDictionary
    }
}
