//
//  String+Casting.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation

public extension String {
    var int: Int? {
        return Int(self)
    }

    var double: Double? {
        return Double(self)
    }
    
    var asBool: Bool? {
        switch self {
        case "false": return false
        case "true": return true
        default: return nil
        }
    }

    func toJSONDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return json as? [String: Any]
    }
    
    func toPreparedUrl() -> URL? {
        guard let url = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: url)
    }
    
    func preparedForUrl() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
