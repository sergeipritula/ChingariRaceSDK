//
//  ViewCustomizer+UICollectionView.swift
//  AppDesign
//
//  Created by Vorko Dmitriy on 03.06.2021.
//

import Foundation
import UIKit

public extension ViewCustomizer where ViewType: UICollectionView {
    @discardableResult
    func set(allowsMultipleSelection: Bool) -> Self {
        view?.allowsMultipleSelection = allowsMultipleSelection
        return self
    }
}
