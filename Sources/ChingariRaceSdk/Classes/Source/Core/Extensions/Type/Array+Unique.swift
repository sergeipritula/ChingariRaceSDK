//
//  Array+Unique.swift
//  Core
//
//  Created by Vorko Dmitriy on 24.06.2021.
//

import Foundation

public extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

public extension Array where Element: Identifiable {
    var withUniqueIds: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.map({ $0.id }).contains(item.id) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

public extension Array {
    func unique<T: Hashable>(by: ((Element) -> (T))) -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self where !set.contains(by(value)) {
            set.insert(by(value))
            arrayOrdered.append(value)
        }
        
        return arrayOrdered
    }
}
