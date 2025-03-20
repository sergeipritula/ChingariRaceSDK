//
//  CHTheme.swift
//  CHDesign
//
//  Created by Ronak Garg on 18/08/23.
//

import UIKit

public enum CHTheme: String {
    case light, dark, system
    
    // Utility var to pass directly to window.overrideUserInterfaceStyle
    public var uiInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .unspecified
        }
    }
    public var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        case .system:
            return .default
        }
    }
    
}

public final class CHThemeManager {
    
    public private(set) var currentTheme: CHTheme = .light
    
    public static let sharedInstance = CHThemeManager()
    
    private init() { }
    
    public func updateTheme(theme: CHTheme) {
        currentTheme = theme
    }
}
