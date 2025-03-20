//
//  RankDetailsCellViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 17.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RankDetailsCellViewModel {
    let imageUrl: String
    let carName: String
    let winrate: String
    let odds: String
    let roadModels: [RoadRankCellViewModel]
    let isFirst: Bool
    let isLast: Bool
    
    init(from model: Car, isFirst: Bool, isLast: Bool) {
        self.imageUrl = model.iconFront
        self.carName = model.name
        self.winrate = "\(model.standartWinRate)%"
        self.odds = model.standartOdds.string
        self.isFirst = isFirst
        self.isLast = isLast
        
        self.roadModels = RoadType.all.map { road in
            let capability = model.getCapability(for: road)
            return RoadRankCellViewModel(road: road, capability: capability)
        }
    }
    
}

class RoadRankCellViewModel {
    let road: RoadType
    let capability: Double
    
    var roadName: String {
        return road.rawValue
    }
    
    var imageRounded: UIImage? {
        return road.imageRounded
    }
    
    init(road: RoadType, capability: Double) {
        self.road = road
        self.capability = capability
    }
}
