//
//  ChingariRaceMyHistoryResponseModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceMyHistoryResponseModel: Codable, Equatable {
    let statusCode: Int
    let message: String
    let data: [ChingariRaceMyHistoryDTO]
}

struct ChingariRaceMyHistoryDTO: Codable, Equatable {
    let sessionId: String
    let sessionTime: String
    let result: Car
    let mySpend: Int
    let myPrizes: Int
}
