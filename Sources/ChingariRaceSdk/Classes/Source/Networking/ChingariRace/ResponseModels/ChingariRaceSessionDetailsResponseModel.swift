//
//  ChingariRaceSessionDetailsResonseModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceSessionDetailsResonseModel: Codable, Equatable {
    let data: ChingariRaceSessionDetailsDTO
    let statusCode: Int
    let message: String
}

struct ChingariRaceSessionDetailsDTO: Codable, Equatable {
    let session: ChingariRaceSession
    let leaderboard: [ChingariRaceSesssionLeaderboardDTO]
    let myWinner: ChingariRaceSesssionLeaderboardDTO?
    let winnersCount: Int
    let tips: Int?
}

struct ChingariRaceSesssionLeaderboardDTO: Codable, Equatable {
    let userId: String
    let userImage: String?
    let userName: String?
    let country: String?
    let prize: Int
    let winnerBetSpend: Int
    let rank: Int
    let totalSpend: Int
}
