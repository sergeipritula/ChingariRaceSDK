//
//  GameNetworkService.swift
//  
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Moya
import RxMoya
import RxSwift
import Foundation

final class GameNetworkService: NetworkMoyaBaseService<GameNetworkMethods> {
    
    private let jsonDecoder = JSONDecoder()
    
    private func dataRequest<T>(endpoint: GameNetworkMethods) -> Single<T> where T: Decodable, T: Equatable {
        return networkProvider.rx.request(endpoint)
            .flatMap { response in
                return Single.just(response)
                    .map(T.self, using: JSONDecoder())
            }
            .map { $0 }
    }
}

extension GameNetworkService: GameNetworkServiceProtocol {
    func configuration(requestData: EmptyRequestData) -> RxSwift.Single<ResponseBaseModel<SdkConfigurationDTO>> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .configuration(requestData: passData))
    }
    
    func token(requestData: GetTokenRequest) -> RxSwift.Single<ResponseBaseModel<GetTokenResponse>> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        
        return dataRequest(endpoint: .token(requestData: passData))
    }
    
}

struct ResponseBaseModel<T: Decodable & Equatable>: Decodable, Equatable {
    let code: Int?
    let message: String?
    let data: T?
}
