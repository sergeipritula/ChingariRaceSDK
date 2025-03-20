//
//  GetTokenRequest.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 18.03.2025.
//

import Foundation

struct GetTokenRequest: Codable, Equatable {
    let userId: String
    let name: String
    let appId: String
    let profilePic: String
}
