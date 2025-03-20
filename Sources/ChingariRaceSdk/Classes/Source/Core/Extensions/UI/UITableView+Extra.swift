//
//  UITableView+Extra.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import UIKit

public extension UITableView {
    func registerHeaderFooterViewClass<T: Reusable>(_ viewType: T.Type) where T: UITableViewHeaderFooterView {
        register(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseID)
    }

    func dequeueReusableHeaderFooterView<T: Reusable>(
        ofType viewType: T.Type
    ) -> T where T: UITableViewHeaderFooterView {
        guard
            let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseID) as? T
        else {
            fatalError("❌ Failed attempt create reusable view \(viewType.reuseID)")
        }
        return view
    }

    func registerCellClass<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        register(cellType, forCellReuseIdentifier: cellType.reuseID)
    }

    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }

    func registerCellNib<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        let nib = UINib(nibName: cellType.reuseID, bundle: Bundle(for: cellType))
        register(nib, forCellReuseIdentifier: cellType.reuseID)
    }

    func dequeueReusableCell<T: Reusable>(
        ofType cellType: T.Type,
        at indexPath: IndexPath
    ) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("❌ Failed attempt create reuse cell \(cellType.reuseID)")
        }
        return cell
    }
}
