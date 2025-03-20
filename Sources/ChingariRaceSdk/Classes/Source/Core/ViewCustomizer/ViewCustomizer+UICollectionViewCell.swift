//
//  ViewCustomizer+UICollectionViewCell.swift
//  ViewCustomizer
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UICollectionViewCell {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.contentView.backgroundColor = backgroundColor
        return self
    }
}
