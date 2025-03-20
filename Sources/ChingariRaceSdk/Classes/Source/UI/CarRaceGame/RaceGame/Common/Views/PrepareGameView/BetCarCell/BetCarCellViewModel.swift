//
//  BetCarCellViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 13.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import RxSwift
import RxCocoa

class BetCarCellViewModel {
    
    let isSelectedRelay = BehaviorRelay<Bool>(value: false)
    let currentBetRelay = BehaviorRelay<Int>(value: 0)
    let placedBetRelay = BehaviorRelay<Int>(value: 0)
    
    let carBet: CarBet
    
    init(from model: CarBet, isSelected: Bool = false) {
        self.carBet = model
        self.isSelectedRelay.accept(isSelected)
    }
}
