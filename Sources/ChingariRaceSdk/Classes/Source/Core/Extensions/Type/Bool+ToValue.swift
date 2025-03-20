//
//  Bool+ToValue.swift
//  Extensions
//
//  Created by Chingari MacBook Pro 16 on 18/05/23.
//

import Foundation

extension Bool {
    
    var stringValue: String {
        self ? "Yes" : "No"
    }
    
    var intValue: Int {
        self ? 1 : 0
    }
}
