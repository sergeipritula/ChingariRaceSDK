//
//  CHShadowView.swift
//  AppDesign
//
//  Created by Chingari MacBook Pro 16 on 08/08/23.
//

import UIKit

public class CHShadowView: CHView {
        
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    public var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    public var model = CHShadowModel() {
        didSet {
            updateValue(from: model)
        }
    }
    
    override public func setupView() {
        super.setupView()
        isUserInteractionEnabled = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateValue(from: model)
    }
    
    public func update(cornerRadius: CGFloat? = nil, corners: UIRectCorner? = nil) {
        model.cornerRadius = cornerRadius
        model.corners = corners
    }
    
    public func update(model: CHShadowModel?) {
        self.model.update(model: model)
    }

    private func updateValue(from model: CHShadowModel) {
        
        gradientLayer.masksToBounds = false
        
        if let type = model.type {
            gradientLayer.shadowColor = type.shadowColor
            gradientLayer.shadowOffset = type.shadowOffset
            gradientLayer.shadowOpacity = type.shadowOpacity
            gradientLayer.shadowRadius = type.shadowRadius
        }
        
        let cornerRadius = model.cornerRadius ?? 0
        let corners = model.corners ?? .allCorners
        gradientLayer.shadowPath = UIBezierPath(roundedRect: bounds,
                                                byRoundingCorners: corners,
                                                cornerRadii: .init(width: cornerRadius,
                                                                   height: cornerRadius)).cgPath
    }
}
