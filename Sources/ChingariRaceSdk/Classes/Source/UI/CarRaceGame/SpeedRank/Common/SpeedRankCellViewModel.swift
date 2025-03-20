//
//  SpeedRankCellViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

class SpeedRankCellViewModel {
    let index: Int
    let model: Car
    let isHighlighted: Bool
    let road: Road
    
    init(
        index: Int,
        model: Car,
        isHighlighted: Bool,
        road: Road
    ) {
        self.index = index
        self.model = model
        self.isHighlighted = isHighlighted
        self.road = road
    }
    
    var speed: Int {
        return Int(model.getCapability(for: road.roadType) * 100)
    }
}
