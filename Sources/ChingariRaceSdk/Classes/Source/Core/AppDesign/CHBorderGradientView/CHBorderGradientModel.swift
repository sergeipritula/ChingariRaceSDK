//
//  CHBorderGradientModel.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 30/05/23.
//

import UIKit

public struct CHBorderGradientModel {
    public var gradientColor: CHGradientColors?
    public var direction: CHGradientDirection?
    public var borderWidth: CGFloat?
    public var cornerRadius: CGFloat?
    public var lineDashPattern: [Int]?
    public var bazierPath: CGPath?
    public var corners: UIRectCorner?
    
    public init(colors: [UIColor]? = nil,
                gradientColor: CHGradientColors? = nil,
                direction: CHGradientDirection? = nil,
                borderWidth: CGFloat? = nil,
                cornerRadius: CGFloat? = nil,
                lineDashPattern: [Int]? = nil,
                bazierPath: CGPath? = nil) {
        if let colors {
            self.gradientColor = .custom(colors: colors)
        } else if let gradientColor {
            self.gradientColor = gradientColor
        }
        self.direction = direction
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.lineDashPattern = lineDashPattern
        self.bazierPath = bazierPath
    }
    
    public mutating func update(model: CHBorderGradientModel?) {
        guard let model else { return }
        
        if let gradientColor = model.gradientColor {
            self.gradientColor = gradientColor
        }
        
        if let direction = model.direction {
            self.direction = direction
        }
        
        if let borderWidth = model.borderWidth {
            self.borderWidth = borderWidth
        }
        
        if let cornerRadius = model.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        
        if let lineDashPattern = model.lineDashPattern {
            self.lineDashPattern = lineDashPattern
        }
        
        if let bazierPath = model.bazierPath {
            self.bazierPath = bazierPath
        }

        if let corners = model.corners {
            self.corners = corners
        }
    }
}
