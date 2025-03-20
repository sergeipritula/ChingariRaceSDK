//
//  ChingariSessionDetailsRequestData.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariSessionDetailsRequestData: Codable, Equatable {
    let offset: Int
    let limit: Int
    let sessionId: String
}
