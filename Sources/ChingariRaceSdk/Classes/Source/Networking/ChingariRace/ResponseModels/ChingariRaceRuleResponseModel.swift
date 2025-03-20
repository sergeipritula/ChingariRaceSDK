//
//  ChingariRaceRuleResponseModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceRuleResponseModel: Codable, Equatable {
    let statusCode: Int
    let message: String
    let data: String
    let error: String?
}
