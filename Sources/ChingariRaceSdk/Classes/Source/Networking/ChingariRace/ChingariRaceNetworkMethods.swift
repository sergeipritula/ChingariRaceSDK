//
//  ChingariRaceNetworkMethods.swift
//  chingari
//
//  Created by Sergey Pritula on 11.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import Moya

enum ChingariRaceNetworkMethods {
    case cars(requestData: RequestModelTypeProtocol)
    case sessionDetails(requestData: RequestModelTypeProtocol)
    case history(requestData: RequestModelTypeProtocol)
    case myHistory(requestData: RequestModelTypeProtocol)
    case rule(requestData: RequestModelTypeProtocol)
    
    private var extractedRequestData: RequestModelTypeProtocol {
        switch self {
        case .cars(let requestData),
                .sessionDetails(let requestData),
                .myHistory(let requestData),
                .history(let requestData),
                .rule(let requestData):
            return requestData
        }
    }
}

extension ChingariRaceNetworkMethods: TargetType {
    
    var baseURL: URL {
        extractedRequestData.baseUrl
    }
    
    var path: String {
        switch self {
        case .cars: return "/racing-game/cars"
        case .sessionDetails: return "/racing-game/session-details"
        case .history: return "/racing-game/history"
        case .myHistory: return "/racing-game/my-history"
        case .rule: return "/racing-game/rule"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cars, .sessionDetails, .history, .myHistory, .rule: return .get
        }
    }
    
    var task: Task {
        guard let parameters = extractedRequestData.parameters else {
            return .requestPlain
        }
        
        switch self {
        case .cars, .rule:
            return .requestPlain
        case .sessionDetails, .history, .myHistory:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
