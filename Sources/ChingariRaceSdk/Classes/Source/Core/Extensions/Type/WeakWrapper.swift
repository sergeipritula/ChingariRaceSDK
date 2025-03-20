//
//  WeakWrapper.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 14.05.2021.
//

import Foundation

open class WeakWraper<T: AnyObject> {
    weak var value: T?

    init(value: T) {
        self.value = value
    }
}
