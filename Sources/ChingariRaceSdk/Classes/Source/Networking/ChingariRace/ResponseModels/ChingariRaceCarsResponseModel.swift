//
//  ChingariRaceCarsResponseModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import Foundation

struct ChingariRaceCarsResponseModel: Codable, Equatable {
    let data: [Car]
    let message: String
    let statusCode: Int
}
