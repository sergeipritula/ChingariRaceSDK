//
//  ResponseBaseModelsProtocol.swift
//  Networking
//
//  Created by Vorko Dmitriy on 16.05.2021.
//

import Foundation

public protocol ResponseBaseModelsProtocol {
    var message: String? { get }
//    var code: Int? { get }
    var error: String? { get }
    var count: Int? { get }
    var serverStatusCode: Int? { get }
}
