//
//  ViewCustomizer+UITableViewCell.swift
//  ViewCustomizer
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UITableViewCell {
    @discardableResult
    func set(backgroundColor: UIColor?) -> Self {
        view?.contentView.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func set(selectionStyle: UITableViewCell.SelectionStyle) -> Self {
        view?.selectionStyle = selectionStyle
        return self
    }
}
