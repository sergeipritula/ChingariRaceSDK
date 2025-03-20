//
//  CompletedResponseModel.swift
//  Networking
//
//  Created by Vorko Dmitriy on 21.06.2021.
//

import Foundation

internal class CompletedResponseModel: Decodable, ResponseBaseModelsProtocol {
    var count: Int?
    let code: Int?
    let message: String?
    let error: String?
    let statusCode: Int?

    var serverStatusCode: Int? {
        guard code != nil else {
            return statusCode
        }
        return code
    }
}
