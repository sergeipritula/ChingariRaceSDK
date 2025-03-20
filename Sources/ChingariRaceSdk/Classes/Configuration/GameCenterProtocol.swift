//
//  GameCenterProtocol.swift
//  chingari-race-sdk
//
//  Created by Sergey Pritula on 12.03.2025.
//

import UIKit

struct GameTheme {
    /// imageNameFromAssets
    var logo: String?
    
    var buttonBackgroundColor: UIColor?
    
    static let `default` = GameTheme(logo: nil, buttonBackgroundColor: nil)
}

enum GameData: String, Codable {
    case userBalance = "USER_BALANCE"
    case betSuccess = "BET_SUCCESS"
    case betFailed = "BET_FAILED"
}

protocol GameCenterProtocol {

    func getGames() -> Result<[Game], Error>

    func setTheme(theme: GameTheme)
    
    func configure(appId: String, isTestEnv: Bool, complition: @escaping ((Bool) -> ()))
    
//    func retrieveToken(username: String, userId: String, completion: @escaping ((String) -> ()))
    
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
