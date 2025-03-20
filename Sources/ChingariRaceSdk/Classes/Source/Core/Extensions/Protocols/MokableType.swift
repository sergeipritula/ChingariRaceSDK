//
//  MokableType.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 27.05.2021.
//

import Foundation

public protocol MockableType {
    static func mocked() -> Self
}
