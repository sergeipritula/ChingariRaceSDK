//
//  CHRoundedButton.swift
//  AdButler
//
//  Created by Vorko Dmitriy on 14.05.2021.
//

import Foundation
import UIKit

public class CHRoundedButton: UIButton {
    // MARK: - Life Cycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
