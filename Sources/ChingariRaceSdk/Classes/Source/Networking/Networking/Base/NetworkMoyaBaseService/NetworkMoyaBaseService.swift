//
//  NetworkMoyaBaseService.swift
//  Networking
//
//  Created by Vorko Dmitriy on 16.05.2021.
//

import Foundation
import Moya

open class NetworkMoyaBaseService<EndpointType: TargetType> {

    // MARK: - Internal Properties

    public var networkProvider: MoyaProvider<EndpointType>

    public var tokenProvider: AuthorizationTokenProvider?
    
    public var uuidProvider: UUIDProvider?

    public var appLanguageProvider: AppLanguageHearderProvider?

    public var baseURL: URL

    // MARK: - Constructor

    public init(baseURL: URL, printRequestLogs: Bool = false, plugins: [PluginType] = []) {
        self.baseURL = baseURL
        var plugins: [PluginType] = plugins
        if printRequestLogs {
            plugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)))
        }
        self.networkProvider = .init(plugins: plugins)
    }
}
