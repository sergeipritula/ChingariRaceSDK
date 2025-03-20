//
//  CHGradientDirection.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 30/05/23.
//

import Foundation

public enum CHGradientDirection {
    case topToBottom
    case leftToRight
    case topLeftToBottomRight
    case bottomLeftToTopRight
    case bottomToTop
    case rightToLeft
    case bottomRightToTopLeft
    case topRightToBottomLeft
    case custom(start: CGPoint, end: CGPoint)
}

extension CHGradientDirection {
    
    var startPoint: CGPoint {
        switch self {
        case .topToBottom: return .init(x: 0.5, y: 0)
        case .leftToRight: return .init(x: 0, y: 0.5)
        case .topLeftToBottomRight: return .init(x: 0, y: 0)
        case .bottomLeftToTopRight: return .init(x: 0, y: 1)
        case .bottomToTop: return .init(x: 0.5, y: 1)
        case .rightToLeft: return .init(x: 1, y: 0.5)
        case .bottomRightToTopLeft: return .init(x: 1, y: 1)
        case .topRightToBottomLeft: return .init(x: 1, y: 0)
        case .custom(let start, _): return start
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .topToBottom: return .init(x: 0.5, y: 1)
        case .leftToRight: return .init(x: 1, y: 0.5)
        case .topLeftToBottomRight: return .init(x: 1, y: 1)
        case .bottomLeftToTopRight: return .init(x: 1, y: 0)
        case .bottomToTop: return .init(x: 0.5, y: 0)
        case .rightToLeft: return .init(x: 0, y: 0.5)
        case .bottomRightToTopLeft: return .init(x: 0, y: 0)
        case .topRightToBottomLeft: return .init(x: 0, y: 1)
        case .custom(_, let end): return end
        }
    }
}
