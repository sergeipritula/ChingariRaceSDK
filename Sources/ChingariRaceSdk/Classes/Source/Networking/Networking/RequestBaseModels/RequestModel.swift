//
//  RequestModel.swift
//  Networking
//
//  Created by Vorko Dmitriy on 14.06.2021.
//

import Foundation

public struct RequestModel: RequestModelTypeProtocol {
    // MARK: - Properties

    public var authorizationToken: String?

    public let baseUrl: URL

    public let pathEnding: String?

    public let customeHeaderParameters: String?

    public var uuid: String?
    // MARK: - Constructor

    public init(
        baseUrl: URL,
        authorizationToken: String? = nil,
        uuid: String?,
        pathEnding: String? = nil,
        appLangauge: String? = nil
    ) {
        self.authorizationToken = authorizationToken
        self.uuid = uuid
        self.baseUrl = baseUrl
        self.pathEnding = pathEnding
        self.customeHeaderParameters = appLangauge
    }
}
