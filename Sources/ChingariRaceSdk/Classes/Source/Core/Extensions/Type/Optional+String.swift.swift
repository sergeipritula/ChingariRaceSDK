//
//  Optional+String.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {
    /// If self is not optional returns self otherwise an empty string
    var orEmpty: String {
        return self ?? ""
    }
}
