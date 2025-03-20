//
//  CHShadowType.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 07/08/23.
//

import UIKit

public enum CHShadowType {
    case small //For fields and buttons
    case medium // For medium size view
    case large // For large views
    
    var shadowColor: CGColor { UIColor.chDarkslateblue.cgColor }
    var shadowOffset: CGSize {
        switch self {
        case .small, .medium: return .init(width: 0, height: -1)
        case .large: return .init(width: 0, height: -2)
        }
    }
    
    var shadowOpacity: Float {
        switch self {
        case .small: return 0.08
        case .medium, .large: return 0.1
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 10
        case .large: return 12
        }
    }
}
