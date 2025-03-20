//
//  ChingariRaceHistoryResponseModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceHistoryResponseModel: Codable, Equatable {
    let statusCode: Int
    let message: String
    let data: [ChingariRaceHistoryDTO]
}

struct ChingariRaceHistoryDTO: Codable, Equatable {
    let sessionId: String
    let sessionTime: String
    let result: Car
    let winnersCount: Int
    let prizes: Int
}
