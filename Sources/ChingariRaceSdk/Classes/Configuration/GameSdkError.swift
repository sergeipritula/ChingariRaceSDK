//
//  GameSdkError.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 18.03.2025.
//

import Foundation

public enum GameSdkError: Error, LocalizedError {
    case unknown
    case notInitialized
    case gameNotImplemented
}

extension GameSdkError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Game SDK: unkown error"
        case .notInitialized:
            return "Game SDK: sdk is not initialized"
        case .gameNotImplemented:
            return "GAME SDK: current game is not implemented"
        }
    }
}
