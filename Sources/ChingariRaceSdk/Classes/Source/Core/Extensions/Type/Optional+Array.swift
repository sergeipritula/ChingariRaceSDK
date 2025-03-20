//
//  Optional+Array.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import Foundation

public extension Optional {
    func orEmptyArray<T>() -> [T] where Wrapped == [T] {
        return self ?? []
    }
}
