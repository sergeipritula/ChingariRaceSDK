//
//  ChingariRace.swift
//  chingari
//
//  Created by Sergey Pritula on 13.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

struct ChingariRaceSession: Codable, Equatable {
    let configuration: ChingariRaceSessionConfiguration
    let carBets: [CarBet]
    let gameId: Int
    let gameName: String
    let membersCount: Int
    let myBets: [ChingariMyBet]?
    let rewardData: [ChingariRaceReward]?
    let sessionId: String
    let state: ChingariRaceSessionState
    let timeLeft: Int
    let totalBetsAmount: Int
    let totalBetsCount: Int
    let road: [Road]
    let result: ChingariRaceResult?
}

enum ChingariRaceSessionState: String, Codable, Equatable {
    case bet = "BET"
    case gameInProgress = "GAME_IN_PROGRESS"
    case processingBets = "PROCESSING_BETS"
    case result = "RESULT"
    case startInProgess = "START_IN_PROGRESS"
}

struct ChingariMyBet: Codable, Equatable {
    let betAmount: Int
    let carBetId: String
}

struct ChingariRaceSessionConfiguration: Codable, Equatable {
    let bets: ChingariRaceSessionConfigurationBets
    let durations: ChingariRaceSessionConfigurationDurations
}

struct ChingariRaceReward: Codable, Equatable {
    let rewardAmount: Int
    let userId: String
}

struct ChingariRaceSessionConfigurationBets: Codable, Equatable {
    let min: Int
    let max: Int
    let step: Int
    let holdStep: Int?
    let holdScaleFactor: Int?
}

struct ChingariRaceSessionConfigurationDurations: Codable, Equatable {
    let bet, gameInProgress, processingBets, result: Int
    let startInProgress: Int
    
    enum CodingKeys: String, CodingKey {
        case bet = "BET"
        case gameInProgress = "GAME_IN_PROGRESS"
        case processingBets = "PROCESSING_BETS"
        case result = "RESULT"
        case startInProgress = "START_IN_PROGRESS"
    }
}

struct CarBet: Codable, Equatable {
    let id: String
    let dynamicWinRate: Double
    let car: Car
    let totalBetAmount: Double
    let dynamicOdds: Double
}

struct Car: Codable, Equatable {
    let standartOdds: Double
    let capabilities: Capabilities
    let id: Int
    let iconFrontThumb: String
    let iconFront: String
    let iconSide: String
    let standartWinRate: Int
    let name: String
    let iconTop: String
}

extension Car {
    func getCapability(for road: RoadType) -> Double {
        switch road {
        case .potholes:
            return capabilities.potholes
        case .bumpy:
            return capabilities.bumpy
        case .dirt:
            return capabilities.dirt
        case .desert:
            return capabilities.desert
        case .highway:
            return capabilities.highway
        case .expressway:
            return capabilities.expressway
        case .unknown:
            return 0
        }
    }
}

struct Capabilities: Codable, Equatable {
    let potholes: Double
    let bumpy: Double
    let dirt: Double
    let desert: Double
    let highway: Double
    let expressway: Double

    enum CodingKeys: String, CodingKey {
        case potholes = "POTHOLES"
        case bumpy = "BUMPY"
        case dirt = "DIRT"
        case desert = "DESERT"
        case highway = "HIGHWAY"
        case expressway = "EXPRESSWAY"
    }
}

struct Road: Codable, Equatable {
    let length: Double
    let roadType: RoadType
}

enum RoadType: String, Codable, Equatable {
    case potholes = "POTHOLES"
    case bumpy = "BUMPY"
    case dirt = "DIRT"
    case desert = "DESERT"
    case highway = "HIGHWAY"
    case expressway = "EXPRESSWAY"
    case unknown = "UNKNOWN"
    
    static var all: [RoadType] {
        return [.potholes, .bumpy, .dirt, .desert, .highway, .expressway]
    }
}

struct ChingariRaceResult: Codable, Equatable {
    let renderData: [RenderData]
    let winner: Winner
}

struct RenderData: Codable, Equatable {
    let carId: Int
    let timeline: [Timeline]
}

struct Timeline: Codable, Equatable {
    let duration: Int
    let length: Double
    let roadType: RoadType
}

struct Winner: Codable, Equatable {
    let car: Car
    let dynamicOdds: Double
    let dynamicWinRate: Double
    let id: String
    let totalBetAmount: Int
}

extension RoadType {
    var image: UIImage? {
        switch self {
        case .potholes:
            return UIImage(named: "race_road_potholes_default")
        case .bumpy:
            return UIImage(named: "race_road_bumpy_default")
        case .dirt:
            return UIImage(named: "race_road_dirt_default")
        case .desert:
            return UIImage(named: "race_road_desert_default")
        case .highway:
            return UIImage(named: "race_road_highway_default")
        case .expressway:
            return UIImage(named: "race_road_expressway_default")
        case .unknown:
            return UIImage(named: "race_road_unknown_default")
        }
    }
    
    var imageFaded: UIImage? {
        switch self {
        case .potholes:
            return UIImage(named: "race_road_potholes_faded")
        case .bumpy:
            return UIImage(named: "race_road_bumpy_faded")
        case .dirt:
            return UIImage(named: "race_road_dirt_faded")
        case .desert:
            return UIImage(named: "race_road_desert_faded")
        case .highway:
            return UIImage(named: "race_road_highway_faded")
        case .expressway:
            return UIImage(named: "race_road_expressway_faded")
        case .unknown:
            return nil
        }
    }
    
    var imageGame: UIImage? {
        switch self {
        case .potholes:
            return UIImage(named: "race_road_potholes_game")
        case .bumpy:
            return UIImage(named: "race_road_bumpy_game")
        case .dirt:
            return UIImage(named: "race_road_dirt_game")
        case .desert:
            return UIImage(named: "race_road_desert_game")
        case .highway:
            return UIImage(named: "race_road_highway_game")
        case .expressway:
            return UIImage(named: "race_road_expressway_game")
        case .unknown:
            return nil
        }
    }
    
    var prepareRoadTitle: String {
        switch self {
        case .potholes:
            return "Potholes"
        case .bumpy:
            return "Bumpy"
        case .dirt:
            return "Dirt"
        case .desert:
            return "Desert"
        case .highway:
            return "Highway"
        case .expressway:
            return "Expressway"
        case .unknown:
            return "???"
        }
    }
    
    var imageRounded: UIImage? {
        switch self {
        case .potholes:
            return UIImage(named: "race_road_potholes_small")
        case .bumpy:
            return UIImage(named: "race_road_bumpy_small")
        case .dirt:
            return UIImage(named: "race_road_dirt_small")
        case .desert:
            return UIImage(named: "race_road_desert_small")
        case .highway:
            return UIImage(named: "race_road_highway_small")
        case .expressway:
            return UIImage(named: "race_road_expressway_small")
        case .unknown:
            return nil
        }
    }
}
