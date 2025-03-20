//
//  CHGradientBackgroundView.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 07/08/23.
//

import UIKit

public class CHGradientBackgroundView: CHView {
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    public var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    override public func setupView() {
        super.setupView()
        isUserInteractionEnabled = false
    }
    
    public var model = CHGradientModel(colors: []) {
        didSet {
            updateGradient(from: model)
        }
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient(from: model)
    }
    
    public func update(cornerRadius: CGFloat? = nil, corners: UIRectCorner? = nil) {
        model.cornerRadius = cornerRadius
        model.corners = corners
    }
    
    public func update(borderWidth: CGFloat?) {
        model.borderWidth = borderWidth
    }
    
    public func update(model: CHGradientModel) {
        self.model.update(model: model)
    }
    
    private func updateGradient(from model: CHGradientModel) {
        
        updateColors(gradientColor: model.gradientColor)
        
        if let direction = model.direction {
            gradientLayer.startPoint = direction.startPoint
            gradientLayer.endPoint = direction.endPoint
        }
        
        if let type = model.type {
            gradientLayer.type = type
        }
  
        if let locations = model.locations {
            gradientLayer.locations = locations.map { NSNumber.init(floatLiteral: $0)}
        }
        
        gradientLayer.mask = maskingLayer(borderWidth: model.borderWidth,
                                          fillColor: .black,
                                          strokeColor: .clear,
                                          path: model.bazierPath,
                                          cornerRadius: model.cornerRadius,
                                          roundingCorners: model.corners)
    }
    
    public func updateColors() {
        updateColors(gradientColor: model.gradientColor)
    }
    
    private func updateColors(gradientColor: CHGradientColors?) {
        guard let colors = gradientColor?.colors, !colors.isEmpty else { return }
        if colors.count > 1 {
            gradientLayer.colors = colors.map({$0.cgColor})
            gradientLayer.backgroundColor = nil
        } else {
            gradientLayer.colors = nil
            gradientLayer.backgroundColor = colors[0].cgColor
        }
    }
}
