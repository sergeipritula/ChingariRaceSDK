//
//  View.swift
//  AppDesign
//
//  Created by Vorko Dmitriy on 14.05.2021.
//

import Foundation
import UIKit

open class CHView: UIView, Accessible {
    // MARK: - Constructor

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupView()
        setupLocalization()
        generateAccessibilityIdentifiers()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupView()
        setupLocalization()
        generateAccessibilityIdentifiers()
    }

    // MARK: - Fucntions

    open func setupView() {}

    open func setupConstraints() {}

    open func setupLocalization() {}
}
