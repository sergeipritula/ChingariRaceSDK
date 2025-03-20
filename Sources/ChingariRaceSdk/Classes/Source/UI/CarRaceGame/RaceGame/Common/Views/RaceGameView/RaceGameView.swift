//
//  RaceGameView.swift
//  chingari
//
//  Created by Sergey Pritula on 12.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RaceGameView: CHView {
    
    private let containerView = UIView()
    
    private let header = RaceGameHeaderView()
    
    private let raceBetsView = RaceGameBetsView()
    
    private let raceGameView = RaceGameProgressView()
    
    private let resultView = RaceResultView()
    
    let itemsRelay = BehaviorRelay<[BetCarCellViewModel]>(value: [])
    
    let sessionSubject: PublishSubject<ChingariRaceSession> = .init()
    
    private var raceInfoSubject = PublishSubject<Void>()
    var raceInfoEvent: PublishSubject<Void> { raceInfoSubject }
    
    private let disposeBag = DisposeBag()
    
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
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(header)
        containerView.addSubview(raceBetsView)
        containerView.addSubview(raceGameView)
        containerView.addSubview(resultView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        header.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        raceBetsView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        raceGameView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.top.equalTo(raceBetsView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        disposeBag.insert([
            setupSessionUpdatedPublisher(),
            setupItemsObserver(),
            setupRaceInfoSubjectObserving()
        ])
    }
    
    private func setupSessionUpdatedPublisher() -> Disposable {
        sessionSubject.asObservable()
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (self, session) in
                self.raceGameView.render(with: session)
                self.header.render(with: session, items: self.itemsRelay.value)
                self.resultView.render(with: session, items: self.itemsRelay.value)
                
                self.raceGameView.isHidden = session.state == .result
                self.header.participantsSegmentView.isHidden = session.state == .result
                self.header.raceResultSegmentView.isHidden = session.state != .result
                self.resultView.isHidden = session.state != .result
            })
    }
    
    private func setupItemsObserver() -> Disposable {
        itemsRelay.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (self, items) in
                self.raceBetsView.render(items: items)
            })
    }
    
    private func setupRaceInfoSubjectObserving() -> Disposable {
        header.raceResultSegmentView.arrowButton.rx.tap.bind(to: raceInfoSubject)
    }
}
