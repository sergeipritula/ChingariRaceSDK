//
//  Reusable.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 12.05.2021.
//  Copyright © 2020 Dmitriy Vorko. All rights reserved.
//

import UIKit

public protocol Reusable {
    static var reuseID: String { get }
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable{}
extension UICollectionViewCell: Reusable{}
