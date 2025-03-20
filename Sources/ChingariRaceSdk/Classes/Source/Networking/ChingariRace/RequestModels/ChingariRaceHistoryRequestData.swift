//
//  ChingariRaceHistoryRequestData.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceHistoryRequestData: Codable, Equatable {
    let offset: Int
    let limit: Int
}
