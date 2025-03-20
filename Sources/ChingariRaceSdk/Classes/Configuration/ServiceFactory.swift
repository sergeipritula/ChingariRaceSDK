//
//  ServiceFactory.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 13.03.2025.
//

import UIKit

class ServiceFactory {
    
    static func makeGameService(networkConfig: NetworkConfigProtocol,
                                printLogs: Bool = false) -> GameNetworkServiceProtocol {
        let service = GameNetworkService(
            baseURL: networkConfig.baseUrl.toUrl()!,
            printRequestLogs: printLogs
        )
        
        service.tokenProvider = TokenAndUUIDProvider.shared
        service.uuidProvider = TokenAndUUIDProvider.shared
        
        return service
    }
    
    static func makeRaceGameService(networkConfig: NetworkConfigProtocol,
                                    printLogs: Bool = false) -> ChingariRaceNetworkServiceProtocol {
        let service = ChingariRaceNetworkService(
            baseURL: networkConfig.baseUrl.toUrl()!,
            printRequestLogs: printLogs
        )
        
        service.tokenProvider = TokenAndUUIDProvider.shared
        service.uuidProvider = TokenAndUUIDProvider.shared
        
        return service
    }
    
}

final class TokenAndUUIDProvider: AuthorizationTokenProvider, UUIDProvider {
    
    static let shared = TokenAndUUIDProvider()
    
    private init() { }
    
    func appId() -> String? {
        TokenStorage.shared.token
    }
    
    func authorizationToken() -> String? {
        TokenStorage.shared.token
    }
    
    func uuidValue() -> String {
        return UUID.uuid
    }

}

extension UUID {
    static var uuid: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "1234567890"
    }
}
