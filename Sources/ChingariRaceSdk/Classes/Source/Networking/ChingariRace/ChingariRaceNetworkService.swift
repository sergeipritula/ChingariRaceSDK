//
//  ChingariRaceNetworkService.swift
//  chingari
//
//  Created by Sergey Pritula on 11.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

final class ChingariRaceNetworkService: NetworkMoyaBaseService<ChingariRaceNetworkMethods> {
    
    private let jsonDecoder = JSONDecoder()
    
    private func dataRequest<T>(endpoint: ChingariRaceNetworkMethods) -> Single<T> where T: Decodable, T: Equatable {
        return networkProvider.rx.request(endpoint)
            .flatMap { response in
                return Single.just(response)
                    .map(T.self, using: JSONDecoder())
            }
            .map { $0 }
    }
}

extension ChingariRaceNetworkService: ChingariRaceNetworkServiceProtocol {

    func cars(requestData: EmptyRequestData) -> RxSwift.Single<ChingariRaceCarsResponseModel> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .cars(requestData: passData))
    }
    
    func sessionDetails(
        requestData: ChingariSessionDetailsRequestData
    ) -> RxSwift.Single<ChingariRaceSessionDetailsResonseModel> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .sessionDetails(requestData: passData))
    }
    
    func history(
        requestData: ChingariRaceHistoryRequestData
    ) -> RxSwift.Single<ChingariRaceHistoryResponseModel> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .history(requestData: passData))
    }
    
    func myHistory(
        requestData: ChingariRaceHistoryRequestData
    ) -> RxSwift.Single<ChingariRaceMyHistoryResponseModel> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .myHistory(requestData: passData))
    }
    
    func rule(requestData: EmptyRequestData) -> RxSwift.Single<ChingariRaceRuleResponseModel> {
        let passData = RequestDataModel(
            sendData: requestData,
            baseUrl: baseURL,
            authorizationToken: tokenProvider?.authorizationToken(),
            uuid: uuidProvider?.uuidValue()
        )
        return dataRequest(endpoint: .rule(requestData: passData))
    }
    
}

