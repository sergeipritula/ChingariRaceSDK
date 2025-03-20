//
//  CHGradientView.swift
//  chingari
//
//  Created by Chingari MacBook Pro 16 on 06/04/23.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//

import UIKit

public class CHGradientView: CHView {
    
    private lazy var gradientView = CHGradientBackgroundView()
    private lazy var shadowView = CHShadowView()
    private lazy var borderView = CHBorderGradientView()
    
    private weak var addedGradientView: CHGradientBackgroundView?
    private weak var addedShadowView: CHShadowView?
    private weak var addedBorderView: CHBorderGradientView?
    
    private var _cornerRadius: CGFloat? = nil
    private var corners: UIRectCorner = .allCorners
    private var _borderWidth: CGFloat? = nil
    
    public init(model: CHGradientModel? = nil,
                borderModel: CHBorderGradientModel? = nil,
                shadowModel: CHShadowModel? = nil,
                cornerRadius: CGFloat? = nil,
                corners: UIRectCorner? = nil) {
        super.init(frame: .zero)
        self._cornerRadius = cornerRadius
        if let corners {
            self.corners = corners
        }
        updateBorderGradientView(model: borderModel)
        updateGradientView(model: model)
        updateShadowView(model: shadowModel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientView.updateColors()
        borderView.updateColors()
    }
    
    override public func setupView() {
        super.setupView()
        backgroundColor = .clear
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    private func updateAddedViews() {
        
        if let addedBorderView {
            insertSubview(addedBorderView, at: 0)
        }
        
        if let addedGradientView {
            insertSubview(addedGradientView, at: 0)
        }
        
        if let addedShadowView {
            insertSubview(addedShadowView, at: 0)
        }
    }
    
    private func insertSubview(view: UIView) {
        insertSubview(view, at: 0)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func update(cornerRadius: CGFloat? = nil, corners: UIRectCorner? = nil) {
        self._cornerRadius = cornerRadius
        if let corners {
            self.corners = corners
        }
        addedGradientView?.update(cornerRadius: cornerRadius, corners: self.corners)
        addedBorderView?.update(cornerRadius: cornerRadius, corners: self.corners)
        addedShadowView?.update(cornerRadius: cornerRadius, corners: self.corners)
    }
}

extension CHGradientView { // Gradient View

    public func updateGradientView(model: CHGradientModel?) {
        if let _cornerRadius {
            self._cornerRadius = _cornerRadius
        }
        guard var model else { return }
        addGradient()
        if let _cornerRadius {
            model.cornerRadius = _cornerRadius
        }
//        model.borderWidth = borderWidth
        model.corners = corners
        gradientView.update(model: model)
        updateAddedViews()
    }
    
    private func addGradient() {
        guard addedGradientView == nil else { return }
        addedGradientView = gradientView
        insertSubview(view: gradientView)
    }
}

extension CHGradientView { // Shadow View
    
    public func updateShadowView(model: CHShadowModel?) {
        guard var model else { return }
        addShadowView()
        if let _cornerRadius {
            model.cornerRadius = _cornerRadius
        }
        model.corners = corners
        shadowView.update(model: model)
        updateAddedViews()
    }
    
    private func addShadowView() {
        guard addedShadowView == nil else { return }
        addedShadowView = shadowView
        insertSubview(view: shadowView)
    }
    
    public func removeShadowView() {
        guard addedShadowView == nil else { return }
        addedShadowView?.removeFromSuperview()
    }
}

extension CHGradientView { // Border View
    
    public func updateBorderGradientView(model: CHBorderGradientModel?) {
        if let _cornerRadius {
            self._cornerRadius = _cornerRadius
        }
        guard var model else { return }
        addBorderView()
        if let _cornerRadius {
            model.cornerRadius = _cornerRadius
        }
        self._borderWidth = model.borderWidth
        model.corners = corners
        borderView.update(model: model)
        addedGradientView?.update(borderWidth: model.borderWidth)
        updateAddedViews()
    }
    
    public func removeBorderModel() {
        addedBorderView?.removeFromSuperview()
        addedBorderView = nil
    }
    
    private func addBorderView() {
        guard addedBorderView == nil else { return }
        addedBorderView = borderView
        insertSubview(view: borderView)
    }
    
}
