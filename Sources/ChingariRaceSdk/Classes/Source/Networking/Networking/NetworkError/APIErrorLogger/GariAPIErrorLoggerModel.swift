//
//  GariAPIErrorLoggerModel.swift
//  AdButler
//
//  Created by Pavan on 16/02/22.
//

import Foundation

public protocol GariAPIErrorLoggerModelType {
    var errorMessage: String? { get }
    var errorCode: Int? { get }
    var urlPath: String? { get }
}

public struct GariAPIErrorLoggerModel {
    public var errorMessage: String?
    public var errorCode: Int?
    public var urlPath: String?
}

extension GariAPIErrorLoggerModel: GariAPIErrorLoggerModelType {}
