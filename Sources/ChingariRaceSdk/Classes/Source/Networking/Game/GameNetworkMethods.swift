//
//  GameNetworkMethods.swift
//  
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Foundation
import Moya

enum GameNetworkMethods {
    case configuration(requestData: RequestModelTypeProtocol)
    case token(requestData: RequestModelTypeProtocol)
    
    private var extractedRequestData: RequestModelTypeProtocol {
        switch self {
        case .configuration(let requestData):
            return requestData
        case .token(let requestData):
            return requestData
        }
    }
}

extension GameNetworkMethods: TargetType {
    
    var baseURL: URL {
        extractedRequestData.baseUrl
    }
    
    var path: String {
        switch self {
        case .configuration: return "partners/status"
        case .token: return "partners/get-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .configuration: return .get
        case .token: return .post
        }
    }
    
    var task: Task {
        guard let parameters = extractedRequestData.parameters else {
            return .requestPlain
        }
        
        switch self {
        case .configuration:
            return .requestPlain
        case .token(let requestData):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        return extractedRequestData.sampleData ?? Data()
    }
    
    var headers: [String : String]? {
        var dict: [String: String] = [:]

        if let accessToken = TokenStorage.shared.token {
            dict["Authorization"] = "Bearer \(accessToken)"
        }
        
        if let appId = TokenStorage.shared.appId {
            dict["AppId"] = appId
        }
        
        dict["packageName"] = "io.chingari.games.ios"
        dict["platform"] = "ios"
        
        dict["user-agent"] = extractedRequestData.uuid
        
        return dict
    }
}
