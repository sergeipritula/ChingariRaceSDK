//
//  Accessible.swift
//  chingari
//
//  Created by Ronak Garg on 10/02/23.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//

import UIKit

public protocol Accessible {
    func generateAccessibilityIdentifiers()
}

public extension Accessible {
    func generateAccessibilityIdentifiers() {
        if AccessiblityManager.sharedInstance.isAccessiblityEnabled {
            let mirror = Mirror(reflecting: self)
            
            for child in mirror.children {
                if let view = child.value as? UIView,
                   let identifier = child.label?.replacingOccurrences(of: ".storage", with: "")
                    .replacingOccurrences(of: "$__lazy_storage_$_", with: "") {
                    view.accessibilityIdentifier = "\(type(of: self)).\(identifier)"
                }
            }
        }
    }
}

public class AccessiblityManager {
    public static let sharedInstance: AccessiblityManager = AccessiblityManager()
    
    private(set) var isAccessiblityEnabled = false
    
    public func shouldEnableAccessiblity(value: Bool) {
        self.isAccessiblityEnabled = value
    }
}
