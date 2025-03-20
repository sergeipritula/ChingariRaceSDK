//
//  SdkConfigurationDTO.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 13.03.2025.
//

import Foundation

struct SdkConfigurationDTO: Codable, Equatable {
    public let isLicenseActive: Bool?
    public let licenseExpireAt: Int?
    public let games: [String]?
}
