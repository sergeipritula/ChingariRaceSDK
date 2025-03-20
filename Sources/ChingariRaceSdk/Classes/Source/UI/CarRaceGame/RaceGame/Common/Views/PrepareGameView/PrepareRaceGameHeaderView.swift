//
//  PrepareRaceGameHeaderView.swift
//  chingari
//
//  Created by Sergey Pritula on 26.08.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PrepareRaceGameHeaderView: CHView {
    
    private var disposeBag = DisposeBag()
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let gameInfoContainer = UIView()
    
    private let gameInfoBackbroundImageView = UIImageView()
    
    private let gameInfoStackView = UIStackView()
    
    private let participantsContainer = UIView()
    
    private let participantsStackView = UIStackView()
    
    private let participantImageView = UIImageView()
    
    private let participantsLabel = UILabel()
    
    private let diamondsContainer = UIView()
    
    private let diamondsStackView = UIStackView()
    
    private let diamondsImageView = UIImageView()
    
    private let diamondsLabel = UILabel()
    
    private let timeContainer = UIView()
    
    private let timeLabel = UILabel()
    
    private let diamondsInfoContainer = UIView()
    
    private let diamondsContainerBackgroundImageView = UIImageView()
    
    private let diamondsInfoContainerView = UIView()

    private let diamondsInfoImageView = UIImageView()
    
    private let diamondsInfoLabel = UILabel()

    private let diamondsInfoButton = UIButton()
    
    let ownDiamondsRelay: BehaviorRelay<Int> = .init(value: 0)
    let timeLeftSubject: PublishSubject<Int> = .init()
    
    private let addDiamondsSubject: PublishSubject<Void> = .init()
    var addDiamondsEvent: RxObservable<Void> { addDiamondsSubject }
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupBindings()
    }
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(alignment: .fill)
            .set(spacing: 8)
        
        gameInfoStackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(alignment: .fill)
        
        participantsStackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(alignment: .center)
            .set(spacing: 2)
        
        diamondsStackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(alignment: .center)
            .set(spacing: 5)
        
        gameInfoContainer.customizer
            .set(backgroundColor: .white)
        
        diamondsContainer.customizer
            .set(backgroundColor: .clear)
        
        gameInfoBackbroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.purpleBackground3))
            .set(contentMode: .scaleToFill)
        
        diamondsContainerBackgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.plusContainer))
            .set(contentMode: .scaleToFill)
        
        [diamondsLabel, diamondsInfoLabel, participantsLabel, timeLabel].forEach {
            $0.customizer
                .set(font: .init(font: .poppinsRegular, style: .caption2))
                .set(textColor: .black)
        }
        
        participantImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.person))
            .set(contentMode: .scaleAspectFit)
        
        [diamondsImageView, diamondsInfoImageView].forEach {
            $0.customizer
                .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
                .set(contentMode: .scaleAspectFit)
        }
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(gameInfoContainer)
        stackView.addArrangedSubview(diamondsInfoContainer)
        
        gameInfoContainer.addSubview(gameInfoBackbroundImageView)
        diamondsInfoContainer.addSubview(diamondsContainerBackgroundImageView)
        
        gameInfoContainer.addSubview(gameInfoStackView)
        
        gameInfoStackView.addArrangedSubview(participantsContainer)
        gameInfoStackView.addArrangedSubview(diamondsContainer)
        gameInfoStackView.addArrangedSubview(timeContainer)
        
        diamondsInfoContainer.addSubview(diamondsInfoContainerView)
        diamondsInfoContainer.addSubview(diamondsInfoButton)
        
        participantsContainer.addSubview(participantsStackView)
        diamondsContainer.addSubview(diamondsStackView)
        timeContainer.addSubview(timeLabel)
        
        participantsStackView.addArrangedSubview(participantImageView)
        participantsStackView.addArrangedSubview(participantsLabel)
        
        diamondsStackView.addArrangedSubview(diamondsImageView)
        diamondsStackView.addArrangedSubview(diamondsLabel)
        
        diamondsInfoContainerView.addSubview(diamondsInfoLabel)
        diamondsInfoContainerView.addSubview(diamondsInfoImageView)
        
        gameInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        participantsContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.29)
        }
        
        diamondsContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        participantsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        diamondsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.21)
        }
        
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gameInfoContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        
        gameInfoBackbroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        diamondsContainerBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        diamondsInfoContainerView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(diamondsInfoButton.snp.leading)
        }
        
        diamondsInfoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.trailing.equalTo(diamondsInfoImageView.snp.leading).offset(-5)
        }
        
        diamondsInfoButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.trailing.top.bottom.equalToSuperview()
        }
        
        [participantImageView, diamondsImageView, diamondsInfoImageView].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(16)
            }
        }
        
        diamondsInfoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        disposeBag.insert(
            setupDiamondsObserving(),
            setupAddDiamondsObserving(),
            setupTimeLeftObserving()
        )
    }
    
    func sessionUpdated(session: ChingariRaceSession) {
        participantsLabel.text = "\(session.membersCount)"
        diamondsLabel.text = "\(session.totalBetsAmount)"
        
        if session.state != .bet {
            self.gameInfoBackbroundImageView.image = UIImage(named: CarRaceGameConstants.Images.purpleBackground3)
        }
    }
    
    private func setupDiamondsObserving() -> Disposable {
        ownDiamondsRelay.map { "\($0)" }.bind(to: diamondsInfoLabel.rx.text)
    }
    
    private func setupTimeLeftObserving() -> Disposable {
        timeLeftSubject.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, seconds) in
                let isRed = seconds <= 10
                let backgroundImage = isRed ? CarRaceGameConstants.Images.purpleBackground3Red : CarRaceGameConstants.Images.purpleBackground3
                self.gameInfoBackbroundImageView.image = UIImage(named: backgroundImage)
                self.timeLabel.textColor = isRed ? .white : .black
                self.timeLabel.text = "\(seconds)s"
            })
    }
    
    private func setupAddDiamondsObserving() -> Disposable {
        diamondsInfoButton.rx.tap.asObservable().bind(to: addDiamondsSubject)
    }
}
