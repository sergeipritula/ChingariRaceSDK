//
//  DataArrayModel.swift
//  Core
//
//  Created by Vorko Dmitriy on 15.06.2021.
//

import Foundation

public struct DataArrayModel<T>: Equatable where T: Decodable, T: Equatable {
    // MARK: - Properties

    public let data: T
    public let count: Int?

    // MARK: - Constructor

    public init(data: T, count: Int?) {
        self.data = data
        self.count = count
    }
}
