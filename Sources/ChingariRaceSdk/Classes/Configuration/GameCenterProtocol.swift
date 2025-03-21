//
//  GameCenterProtocol.swift
//  chingari-race-sdk
//
//  Created by Sergey Pritula on 12.03.2025.
//

import UIKit

public struct GameTheme {
    /// imageNameFromAssets
    public var logo: String?
    
    public var buttonBackgroundColor: UIColor?
    
    public init(logo: String?, buttonBackgroundColor: UIColor?) {
        self.logo = logo
        self.buttonBackgroundColor = buttonBackgroundColor
    }
    
    public static let `default` = GameTheme(logo: nil, buttonBackgroundColor: nil)
}

public enum GameData: String, Codable {
    case userBalance = "USER_BALANCE"
    case betSuccess = "BET_SUCCESS"
    case betFailed = "BET_FAILED"
}

public protocol GameCenterProtocol {

    func getGames() -> Result<[Game], GameSdkError>

    func setTheme(theme: GameTheme)
    
    func configure(appId: String, isTestEnv: Bool, complition: @escaping ((Bool) -> ()))
    
    func retrieveToken(appId: String,
                       username: String,
                       userId: String,
                       profileImage: String, completion: @escaping ((String) -> ()))
    
    func joinGame(presentingController: UIViewController,
                  game: Game,
                  token: String,
                  userId: String,
                  listener: GameCenterDelegate,
                  completion: @escaping ((GameSdkError?) -> ()))

    func updateGameData(key: GameData, value: String)

    func setBalance(_ value: Int)
    
    func updateBalance(_ value: Int) 
    
    func leaveGame()

}
