//
//  GameCenter.swift
//  chingari-race-sdk
//
//  Created by Sergey Pritula on 10.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

public protocol GameCenterDelegate: AnyObject {
    func openDiamondStore()
    
    func openLeaderboard()
    
    func onGameEvent(event: String, data: String)
    
    func makeBet(requestId: String, amount: Int)
    
    func onError(code: Int, description: String)
    
    func didBetSuccess()
    
    func didBetFailed()
}

public protocol GameDataUpdateProtocol: AnyObject {
    func didBalanceUpdated(balance: Int)
    
    func didBetSuccess()
    
    func didBetFailed()
}

public class GameCenter: GameCenterProtocol {
    
    private var appId: String?
    private var isTestEnv: Bool?
//    private var chingariGame: ChingariGame?
    private var sdkConfiguration: SdkConfigurationDTO?
    
    weak var delegate: GameCenterDelegate?
    weak var updateDelegate: GameDataUpdateProtocol?
    
    weak var dataUpdater: GameDataUpdateProtocol?
    
    public static var shared: GameCenter = GameCenter()
    
    private(set) var diamondSubject = BehaviorRelay<Int>(value: 0)
    
    private init() {}
    
    private(set) var gameTheme: GameTheme = .default
    private var gameCoordinator: RaceGameCoordinator?
    private var socketManager = ChingariRaceService(tokenProvider: TokenAndUUIDProvider.shared)
    
    private lazy var networkingManager: ChingariRaceNetworkServiceProtocol = {
        let isTestEnv = self.isTestEnv ?? false
        let config: NetworkConfigProtocol = isTestEnv ? NetworkConfigDev(): NetworkConfigProd()
        let service = ServiceFactory.makeRaceGameService(networkConfig: config, printLogs: false)
        return service
    }()
    
    private lazy var gamesNetworkingManager: GameNetworkServiceProtocol = {
        let isTestEnv = self.isTestEnv ?? false
        let config: NetworkConfigProtocol = isTestEnv ? NetworkConfigDev(): NetworkConfigProd()
        let service = ServiceFactory.makeGameService(networkConfig: config, printLogs: false)
        return service
    }()
    
    private var disposeBag = DisposeBag()
    
    public func configure(appId: String, isTestEnv: Bool, complition completion: @escaping ((Bool) -> ())) {
        self.appId = appId
        self.isTestEnv = isTestEnv
        
        TokenStorage.shared.set(appId: appId)
        
        gamesNetworkingManager.configuration(requestData: .init())
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                self?.sdkConfiguration = response.data
                completion(true)
            }, onError: { [weak self] error in
                completion(false)
            })
            .disposed(by: self.disposeBag)
    }
   
    public func getGames() -> Result<[Game], GameSdkError> {
        guard let sdkConfiguration = sdkConfiguration else {
            return .failure(.gameNotImplemented)
        }
        
        let games = sdkConfiguration.games?.compactMap { Game(rawValue: $0) } ?? []
        return .success(games)
    }
    
    public func setTheme(theme: GameTheme) {
        self.gameTheme = theme
    }
    
    public func updateGameData(key: GameData, value: String) {
        
    }
    
    public func leaveGame() {
        
    }
    
    public func joinGame(presentingController: UIViewController,
                  game: Game,
                  token: String,
                  userId: String,
                  listener: GameCenterDelegate,
                  completion: @escaping ((GameSdkError?) -> ())) {
        TokenStorage.shared.set(token: token)
        TokenStorage.shared.set(userId: userId)
        
        self.delegate = listener
        
        guard game == .racing else {
            completion(.gameNotImplemented)
            return
        }
        
        socketManager.connect(completion: { [weak self] in })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { [weak self] in
            guard let self = self else { return }
            
            self.socketManager.joinRaceGame(data: .init(gameId: game.rawValue))
                .asObservable()
                .subscribe(onNext: { [weak self] model in
                    guard let self = self else { return }
                    
                    let injections = RaceGameCoordinator.Injections(presentedController: presentingController,
                                                                    service: socketManager,
                                                                    networkService: networkingManager,
                                                                    session: model.data)
                    
                    self.gameCoordinator = .init(injections: injections)
                    
                    self.gameCoordinator?.start()
                        .subscribe(onNext: { [weak self] in
                            self?.gameCoordinator = nil
                            self?.socketManager.unsubscribeSessionUpdate()
                            self?.socketManager.disconnect()
                        })
                        .disposed(by: self.disposeBag)
                    
                    completion(nil)
                }, onError: { _ in
                    completion(.none)
                })
                .disposed(by: self.disposeBag)
        })
    }
    
//    func retrieveToken(username: String, userId: String, completion: @escaping ((String) -> ())) {
//        guard let appId = TokenStorage.shared.appId else { return }
//        
//        gamesNetworkingManager.token(requestData: .init(userId: userId,
//                                                        name: username,
//                                                        appId: appId,
//                                                        profilePic: Constants.profileImage))
//        .asObservable()
//        .subscribe(onNext: { response in
//            guard let token = response.data?.token else { return }
//            completion(token)
//        })
//        .disposed(by: self.disposeBag)
//    }
    
    func setDelegate(_ delegate: GameCenterDelegate) {
        self.delegate = delegate
    }
    
    public func setBalance(_ value: Int) {
        self.diamondSubject.accept(value)
    }
    
    public func updateBalance(_ value: Int) {
        let total = self.diamondSubject.value
        self.diamondSubject.accept(total + value)
    }
    
    func leave() {
        
    }
    
}
