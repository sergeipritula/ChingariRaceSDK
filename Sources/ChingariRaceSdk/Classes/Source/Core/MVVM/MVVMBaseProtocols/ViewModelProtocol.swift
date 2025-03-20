//
//  ViewModelProtocol.swift
//  MVVM
//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import Foundation

public protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input, outputHandler: @escaping (_ output: Output) -> Void)
}
