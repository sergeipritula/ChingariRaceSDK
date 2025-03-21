//
//  RaceResultView.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import AVFoundation

class RaceResultView: CHView {
    
    private let containerView = UIView()
    
    private let resultContainer = UIView()
    
    private let raceResultBackgroundImageView = UIImageView()
    
    private let resultLabel = UILabel()
    
    private let detailsLabel = UILabel()
    
    private let carImageView = UIImageView()
    
    private var timer: Timer?
    private var timeLeft = 0
    
    private var audioPlayer: AVAudioPlayer?
    
    override func setupView() {
        containerView.backgroundColor = .clear
        
        resultContainer.layer.cornerRadius = 16
        
        raceResultBackgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.raceResultBackground, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        carImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.monsterTruckSmall, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(resultContainer)
        containerView.addSubview(carImageView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        resultContainer.addSubviews([raceResultBackgroundImageView, resultLabel, detailsLabel])
        
        raceResultBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        carImageView.snp.makeConstraints {
            $0.width.height.equalTo(150)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        resultContainer.snp.makeConstraints {
            $0.top.equalTo(carImageView.snp.bottom).offset(-75)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        detailsLabel.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func render(with session: ChingariRaceSession, items: [BetCarCellViewModel]) {
        carImageView.image = nil
        
        guard session.state == .result, let result = session.result else { return }
        
        self.timeLeft = session.timeLeft / 1000
        
        if let winner = session.result?.winner {
            if let url = URL(string: winner.car.iconFront) {
                carImageView.sd_setImage(with: url)
            }
        }
        
        // TODO: - refactor all this part of code
        
        let placedBets = items.filter { $0.currentBetRelay.value > 0 }.map { $0.carBet }
        let isPlacedBet = placedBets.count > 0
        let rewards = session.rewardData ?? []
        let isWin = rewards.filter { $0.userId == TokenStorage.shared.userId }.count > 0
        let rewardAmount = rewards.first(where: { $0.userId == TokenStorage.shared.userId })?.rewardAmount ?? 0
        
        let winsLoooseResult: RaceResultStatus = isWin ?
            .win(result: result, timeLeft: self.timeLeft, amount: rewardAmount):
            .loose(result: result, timeLeft: self.timeLeft)
        
        let status = isPlacedBet ? winsLoooseResult: .notJoined(result: result, timeLeft: self.timeLeft)
        
        if session.state == .result {
            switch status {
            case .win:
                self.playSound(filename: CarRaceGameConstants.Audio.win)
            case .loose:
                self.playSound(filename: CarRaceGameConstants.Audio.loose)
            case .notJoined:
                break
            }
        }
        
        var foregroundColor: UIColor = .white
        
        let attachment = NSTextAttachment()
        
        switch status {
        case .win:
            foregroundColor = UIColor(hexString: "#FFB872")
            attachment.image = UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil)
            attachment.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
        case .loose:
            foregroundColor = .clear
        case .notJoined:
            foregroundColor = UIColor(hexString: "#877B93")
        }
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white,
            .foregroundColor: foregroundColor,
            .strokeWidth: -3.0,
            .font: CHFont(font: .poppinsBold, style: .largeTitle).uiFont
        ]
        
        let attributedString = NSAttributedString(string: status.title, attributes: strokeTextAttributes)
        self.resultLabel.attributedText = attributedString
        
        let diamondsAttributedString = NSMutableAttributedString(string: status.detailsTitle, attributes: [
            .foregroundColor: UIColor.white,
            .font: CHFont(font: .poppinsRegular, style: .caption1).uiFont
        ])
        
        switch status {
        case .win:
            diamondsAttributedString.append(NSAttributedString(attachment: attachment))
            
            let timeAttributedString = NSMutableAttributedString(string: ", Next \(self.timeLeft)s", attributes: [
                .foregroundColor: UIColor.white,
                .font: CHFont(font: .poppinsRegular, style: .caption1).uiFont
            ])
            diamondsAttributedString.append(timeAttributedString)
            GameCenter.shared.updateBalance(rewardAmount)
        default:
            break
        }
        
        self.detailsLabel.attributedText = diamondsAttributedString
        
        self.timeLeft = session.timeLeft / 1000
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            var foregroundColor: UIColor = .white
            
            let attachment = NSTextAttachment()
            
            let placedBets = items.filter { $0.currentBetRelay.value > 0 }.map { $0.carBet }
            let isPlacedBet = placedBets.count > 0
            let rewards = session.rewardData ?? []
            let isWin = rewards.filter { $0.userId == TokenStorage.shared.userId }.count > 0
            let rewardAmount = rewards.first(where: { $0.userId == TokenStorage.shared.userId })?.rewardAmount ?? 0
            
            let winsLoooseResult: RaceResultStatus = isWin ?
                .win(result: result, timeLeft: self.timeLeft, amount: rewardAmount):
                .loose(result: result, timeLeft: self.timeLeft)
            
            let status = isPlacedBet ? winsLoooseResult: .notJoined(result: result, timeLeft: self.timeLeft)
            
            switch status {
            case .win:
                foregroundColor = UIColor(hexString: "#FFB872")
                attachment.image = UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil)
                attachment.bounds = CGRect(x: 0, y: -4, width: 16, height: 16)
            case .loose:
                foregroundColor = .clear
            case .notJoined:
                foregroundColor = UIColor(hexString: "#877B93")
            }
            
            let strokeTextAttributes: [NSAttributedString.Key: Any] = [
                .strokeColor: UIColor.white,
                .foregroundColor: foregroundColor,
                .strokeWidth: -3.0,
                .font: CHFont(font: .poppinsBold, style: .largeTitle).uiFont
            ]
            
            let attributedString = NSAttributedString(string: status.title, attributes: strokeTextAttributes)
            self.resultLabel.attributedText = attributedString
            
            let diamondsAttributedString = NSMutableAttributedString(string: status.detailsTitle, attributes: [
                .foregroundColor: UIColor.white,
                .font: CHFont(font: .poppinsRegular, style: .caption1).uiFont
            ])
            
            switch status {
            case .win:
                diamondsAttributedString.append(NSAttributedString(attachment: attachment))
                
                let timeAttributedString = NSMutableAttributedString(string: ", Next \(self.timeLeft)s", attributes: [
                    .foregroundColor: UIColor.white,
                    .font: CHFont(font: .poppinsRegular, style: .caption1).uiFont
                ])
                diamondsAttributedString.append(timeAttributedString)
            default:
                break
            }
            
            self.detailsLabel.attributedText = diamondsAttributedString
            
            self.timeLeft -= 1
            
            if self.timeLeft <= 0 {
                timer.invalidate()
            }
        }
    }

    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "aac") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error loading sound file: \(error)")
        }
    }

    
}

enum RaceResultStatus {
    case win(result: ChingariRaceResult, timeLeft: Int, amount: Int)
    case loose(result: ChingariRaceResult, timeLeft: Int)
    case notJoined(result: ChingariRaceResult, timeLeft: Int)
}

extension RaceResultStatus {
    var title: String {
        switch self {
        case .win:
            return "YOU WIN"
        case .loose:
            return "YOU LOOSE"
        case .notJoined:
            return "NOT JOINED"
        }
    }
    
    var detailsTitle: String {
        switch self {
        case .win(result: let result, let timeLeft, let amount):
            return "Reward \(amount)"
        case .loose(result: let result, let timeLeft):
            return "\(result.winner.car.name.capitalized) won, Next \(timeLeft)s"
        case .notJoined(result: let result, let timeLeft):
            return "\(result.winner.car.name.capitalized) won, Next \(timeLeft)s"
        }
    }
}
