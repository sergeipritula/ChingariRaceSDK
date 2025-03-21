//
//  RaceGameHeaderView.swift
//  chingari
//
//  Created by Sergey Pritula on 12.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceGameHeaderView: CHView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private(set) var participantsSegmentView = ParticipantsSegmentView()
    
    private(set) var raceResultSegmentView = RaceResultSegmentView()
    
    override func setupView() {
        containerView.backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 10)
            .set(distribution: .fillEqually)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(participantsSegmentView)
        stackView.addArrangedSubview(raceResultSegmentView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        participantsSegmentView.snp.makeConstraints {
            $0.width.equalTo(containerView).multipliedBy(0.65)
        }
        
        raceResultSegmentView.snp.makeConstraints {
            $0.width.equalTo(containerView).multipliedBy(0.65)
        }
    }
    
    func render(with session: ChingariRaceSession, items: [BetCarCellViewModel]) {
        participantsSegmentView.render(with: session, items: items)
        raceResultSegmentView.render(with: session, items: items)
    }

}
        
class ParticipantsSegmentView: CHView {
    
    private let containerView = UIView()
    
    private let backgroundImageView = UIImageView()
    
    private let stackView = UIStackView()
    
    private let participantsContainerView = UIView()
    
    private let participantsStackView = UIStackView()
    
    private let participantsImageView = UIImageView()
    
    private let participantsLabel = UILabel()
    
    private let diamondsContainerView = UIView()
    
    private let diamondsStackView = UIStackView()
    
    private let diamondsImageView = UIImageView()
    
    private let diamondsLabel = UILabel()
    
    override func setupView() {
        containerView.backgroundColor = .clear
        
        backgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.resultRaceContainer, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        participantsStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        diamondsStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        participantsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.person, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        diamondsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        [participantsLabel, diamondsLabel].forEach {
            $0.customizer
                .set(textColor: .black)
                .set(font: .systemFont(ofSize: 10))
        }
        
        func render(with session: ChingariRaceSession) {
            
        }
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(participantsContainerView)
        stackView.addArrangedSubview(diamondsContainerView)
        
        participantsContainerView.addSubview(participantsStackView)
        diamondsContainerView.addSubview(diamondsStackView)
        
        participantsStackView.addArrangedSubview(participantsImageView)
        participantsStackView.addArrangedSubview(participantsLabel)
        
        diamondsStackView.addArrangedSubview(diamondsImageView)
        diamondsStackView.addArrangedSubview(diamondsLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        participantsContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        diamondsContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.65)
        }
        
        participantsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        diamondsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [participantsImageView, diamondsImageView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(16)
                $0.height.equalTo(16)
            }
        }
        
    }
    
    func render(with session: ChingariRaceSession, items: [BetCarCellViewModel]) {
        participantsLabel.text = session.membersCount.stringValue
        diamondsLabel.text = session.totalBetsAmount.stringValue
    }
    
}

class RaceResultSegmentView: CHView {
    
    private let containerView = UIView()
    
    private let backgroundImageView = UIImageView()
    
    private let stackView = UIStackView()
    
    private let participantsContainerView = UIView()
    
    private let participantsStackView = UIStackView()
    
    private let participantsImageView = UIImageView()
    
    private let participantsLabel = UILabel()
    
    private let diamondsContainerView = UIView()
    
    private let diamondsStackView = UIStackView()
    
    private let diamondsImageView = UIImageView()
    
    private let diamondsLabel = UILabel()
    
    private(set) var arrowButton = UIButton()
    
    override func setupView() {
        containerView.backgroundColor = .clear
        
        backgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.resultRaceContainerDiamonds, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleToFill)
        
        participantsStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        diamondsStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        participantsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        diamondsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        [participantsLabel, diamondsLabel].forEach {
            $0.customizer
                .set(textColor: .black)
                .set(font: .systemFont(ofSize: 10))
        }
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(stackView)
        containerView.addSubview(arrowButton)
        
        stackView.addArrangedSubview(participantsContainerView)
        stackView.addArrangedSubview(diamondsContainerView)
        
        participantsContainerView.addSubview(participantsStackView)
        diamondsContainerView.addSubview(diamondsStackView)
        
        participantsStackView.addArrangedSubview(participantsImageView)
        participantsStackView.addArrangedSubview(participantsLabel)
        
        diamondsStackView.addArrangedSubview(diamondsImageView)
        diamondsStackView.addArrangedSubview(diamondsLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        participantsContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
        
        diamondsContainerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.65)
        }
        
        participantsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        diamondsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [participantsImageView, diamondsImageView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(16)
                $0.height.equalTo(16)
            }
        }
        
        arrowButton.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(32)
        }
    }
    
    func render(with session: ChingariRaceSession, items: [BetCarCellViewModel]) {
        diamondsLabel.text = session.totalBetsAmount.stringValue
        
        let myTotalBets = items.reduce(0) { result, bet in
            result + bet.currentBetRelay.value
        }
        participantsLabel.text = myTotalBets.stringValue
    }
    
}
