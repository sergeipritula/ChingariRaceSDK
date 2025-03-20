//
// Optional+Bool.swift
// Pods
//
//  Created by Vorko Dmitriy on 12.05.2021.
// Copyright © 2020.  All rights reserved.

import Foundation

public extension Optional where Wrapped == Bool {
    var orFalse: Bool {
        return self ?? false
    }

    var orTrue: Bool {
        return self ?? true
    }
}
