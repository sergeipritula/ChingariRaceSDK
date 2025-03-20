//
//  CHBorderGradientView.swift
//  CHDesign
//
//  Created by Chingari MacBook Pro 16 on 06/04/23.
//

import UIKit

final public class CHBorderGradientView: CHView {

    public override class var layerClass: AnyClass { get { CAGradientLayer.self } }
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    public var model = CHBorderGradientModel() {
        didSet {
            updateValues(from: model)
        }
    }
    
    public init(model: CHBorderGradientModel? = nil) {
        super.init(frame: .zero)
        self.model.update(model: model)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func setupView() {
        super.setupView()
        isUserInteractionEnabled = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateValues(from: model)
    }
    
    public func update(cornerRadius: CGFloat? = nil, corners: UIRectCorner? = nil) {
        model.cornerRadius = cornerRadius
        model.corners = corners
    }
    
    public func update(model: CHBorderGradientModel) {
        self.model.update(model: model)
    }
                           
    private func updateValues(from model: CHBorderGradientModel) {
        
        updateColors(gradientColor: model.gradientColor)
        
        if let direction = model.direction {
            gradientLayer.startPoint = direction.startPoint
            gradientLayer.endPoint = direction.endPoint
        }
        
        gradientLayer.mask = maskingLayer(borderWidth: model.borderWidth,
                                          lineDashPattern: model.lineDashPattern,
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
