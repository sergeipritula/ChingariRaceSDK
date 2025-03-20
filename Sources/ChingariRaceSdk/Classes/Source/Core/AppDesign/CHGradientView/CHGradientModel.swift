//
//  CHGradientModel.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 30/05/23.
//

import UIKit

public struct CHGradientModel {
    public var gradientColor: CHGradientColors?
    public var direction: CHGradientDirection?
    public var type: CAGradientLayerType?
    public var cornerRadius: CGFloat?
    public var bazierPath: CGPath?
    public var locations: [Double]?
    public var borderWidth: CGFloat?
    public var corners: UIRectCorner?
    
    public init(colors: [UIColor]? = nil,
                gradientColor: CHGradientColors? = nil,
                direction: CHGradientDirection? = nil,
                type: CAGradientLayerType? = nil,
                bazierPath: CGPath? = nil,
                locations: [Double]? = nil) {
        if let colors {
            self.gradientColor = .custom(colors: colors)
        } else if let gradientColor {
            self.gradientColor = gradientColor
        }
        self.direction = direction
        self.type = type
        self.bazierPath = bazierPath
        self.locations = locations
    }
        
    public mutating func update(model: CHGradientModel) {
        
        if let gradientColor = model.gradientColor {
            self.gradientColor = gradientColor
        }
        
        if let direction = model.direction {
            self.direction = direction
        }
        
        if let type = model.type {
            self.type = type
        }

        if let cornerRadius = model.cornerRadius {
            self.cornerRadius = cornerRadius
        }
        
        if let bazierPath = model.bazierPath {
            self.bazierPath = bazierPath
        }
        
        if let locations = model.locations {
            self.locations = locations
        }
        
        if let borderWidth = model.borderWidth {
            self.borderWidth = borderWidth
        }
        
        if let corners = model.corners {
            self.corners = corners
        }
    }
}
