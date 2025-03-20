//
//  ChingariRaceNetworkServiceProtocol.swift
//  chingari
//
//  Created by Sergey Pritula on 11.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation
import RxSwift

internal protocol ChingariRaceNetworkServiceProtocol {
    func cars(requestData: EmptyRequestData) -> Single<ChingariRaceCarsResponseModel>
    func sessionDetails(requestData: ChingariSessionDetailsRequestData) -> Single<ChingariRaceSessionDetailsResonseModel>
    func history(requestData: ChingariRaceHistoryRequestData) -> Single<ChingariRaceHistoryResponseModel>
    func myHistory(requestData: ChingariRaceHistoryRequestData) -> Single<ChingariRaceMyHistoryResponseModel>
    func rule(requestData: EmptyRequestData) -> Single<ChingariRaceRuleResponseModel>
}
