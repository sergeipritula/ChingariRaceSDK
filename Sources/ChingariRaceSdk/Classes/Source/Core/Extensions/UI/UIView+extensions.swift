//
//  UIViewExtensions.swift
//  expense-tracker
//
//  Created by Nikola Milic on 6/5/20.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit
//import SDWebImage
import RxSwift
//import RxGesture

extension UIView {
    func fadeIn(_ duration: TimeInterval? = 0.3, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        }
        )
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.1, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
            self.isHidden = true
            if let complete = onCompletion { complete() }
        })
    }
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    func getAllSubviews<T: UIView>(type: T.Type) -> [T] {
        return self.subviews.flatMap { subView -> [T] in
            var result = subView.getAllSubviews() as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
    
    func setCornerRadius(to value: CGFloat) {
        self.layer.masksToBounds = true
        clipsToBounds = true
        self.layer.cornerRadius = value
    }
    
    struct ShadowConfiguration {
        let color: UIColor
        let offset: CGSize
        let opacity: Float
        let radius: CGFloat
        
        static let blackShadow: ShadowConfiguration = .init(
            color: .black.withAlphaComponent(0.25),
            offset: .init(width: 0, height: 4),
            opacity: 0.25,
            radius: 4
        )
        
        static let greyShadow: ShadowConfiguration = .init(
            color: .black.withAlphaComponent(0.06),
            offset: .init(width: 0, height: 4),
            opacity: 1,
            radius: 4
        )
    }
    
    func addShadow(with configuration: ShadowConfiguration) {
        layer.shadowColor = configuration.color.cgColor
        layer.shadowOffset = configuration.offset
        layer.shadowOpacity = configuration.opacity
        layer.shadowRadius = configuration.radius
        layer.masksToBounds = false
    }
    
    func addShadow(with color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                   offset: CGSize = CGSize(width: 0.0, height: 5.0),
                   shadowOpacity: Float = 0.25,
                   shadowRadius: CGFloat = 2.0,
                   scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addInnerShadow(with color: UIColor = UIColor.lightGray,
                        shadowOpacity: Float = 1,
                        shadowRadius: CGFloat = 6,
                        borderWidth: CGFloat = 1,
                        borderColor: UIColor = UIColor.white,
                        cornerRadius: CGFloat = 16) {
        self.backgroundColor = .clear
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    @discardableResult
    func addBottomLine(color: UIColor = UIColor.gray, height: CGFloat = 1, spaceToBottom: CGFloat = 0, cornerRadius: CGFloat = 0) -> UIView {
        let bottomLine = UIView()
        bottomLine.layer.cornerRadius = cornerRadius
        addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: height).isActive = true
        let bottomSpace = NSLayoutConstraint(item: bottomLine,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: spaceToBottom * (-1))
        bottomSpace.isActive = true
        bottomLine.backgroundColor = color
        return bottomLine
    }
}

extension UIView {
    
    func fillSuperview() {
        anchorEdge(top: superview?.topAnchor, bottom: superview?.bottomAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView, multiplier: CGSize = CGSize(width: 1, height: 1)) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier.width).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier.height).isActive = true
        layoutIfNeeded()
    }
    
    func anchorEdge(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil,  padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        layoutIfNeeded()
    }
    
    func anchorCenter(centerX: NSLayoutXAxisAnchor? = nil,
                      xOffset: CGFloat = 0,
                      centerY: NSLayoutYAxisAnchor? = nil,
                      yOffset: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: xOffset).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: yOffset).isActive = true
        }
        layoutIfNeeded()
    }
    
    func anchorSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        layoutIfNeeded()
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopRotate360() {
        self.layer.removeAllAnimations()
    }
    
    func rotate(_ isInitial: Bool) {
        UIView.animate(withDuration: 0.25) {
            if isInitial {
                self.transform = CGAffineTransform.identity
            } else {
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            }
        }
    }
    
    func animateLayout(duration: Double) {
        self.setNeedsLayout()
        UIView.animate(withDuration: duration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
}

extension UIView {
    // MARK: - IBInspectable Methods
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}

//extension UIView {
//    public var pan: RxObservable<UIPanGestureRecognizer> {
//        return self.rx.panGesture().when(.began, .changed, .ended).asObservable()
//    }
//    
//    public func panSubscribe(_ subscribe: @escaping (UIPanGestureRecognizer?) -> ()) -> Disposable {
//        return self.pan.subscribe { subscribe($0.element) }
//    }
//}

extension UIView {
    class func instantiateFromNib() -> Self {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! Self
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCornersMask(corners: UIRectCorner, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners.cornerMask
    }
    
    func layoutConstraint(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func roundedView(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func hexagonView(lineWidth: CGFloat = 1, cornerRadius: CGFloat = 10) {
        let path = roundedPolygonPath(rect: self.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: cornerRadius, rotationOffset: .zero)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = lineWidth
        border.strokeColor = UIColor.white.cgColor
        border.fillColor = UIColor.clear.cgColor
        layer.addSublayer(border)
    }
    
    private func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = .zero) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides)
        let width = min(rect.size.width, rect.size.height)
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0..<sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
}

// MARK: - Xib load routine
extension UIView {
    func nibSetup() {
        backgroundColor = .clear
        
        let subView = loadViewFromNib()
        subView.frame = bounds
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.clipsToBounds = true
        addSubview(subView)
        
        self.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: subView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 0).isActive = true
        subView.backgroundColor = .clear
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
        return nibView
    }
    
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIRectCorner {
    var cornerMask: CACornerMask {
        var cornersMask = CACornerMask()
        if self.contains(.topLeft) {
            cornersMask.insert(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            cornersMask.insert(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) {
            cornersMask.insert(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) {
            cornersMask.insert(.layerMaxXMaxYCorner)
        }
        return cornersMask
    }
}
