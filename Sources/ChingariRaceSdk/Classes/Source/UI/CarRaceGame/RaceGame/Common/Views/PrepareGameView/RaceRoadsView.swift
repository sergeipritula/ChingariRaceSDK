//
//  RaceRoadsView.swift
//  chingari
//
//  Created by Sergey Pritula on 26.08.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RaceRoadsView: CHView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let firstRoadView = RaceRoadView()
    
    private let secondRoadView = RaceRoadView()
    
    private let thirdRoadView = RaceRoadView()
    
    private let roadSubject = PublishSubject<Road>()
    var roadClickEvent: RxObservable<Road> { roadSubject }
    
    private var disposeBag = DisposeBag()
    
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
        containerView.backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fillEqually)
            .set(alignment: .fill)
            .set(spacing: 0)
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(62)
        }
        
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(firstRoadView)
        stackView.addArrangedSubview(secondRoadView)
        stackView.addArrangedSubview(thirdRoadView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func render(roads: [Road]) {
        for i in 0..<roads.count {
            switch i {
            case 0:
                setupRoad(view: firstRoadView, road: roads[i])
            case 1:
                setupRoad(view: secondRoadView, road: roads[i])
            case 2:
                setupRoad(view: thirdRoadView, road: roads[i])
            default:
                break
            }
        }
        
    }
    
    private func setupRoad(view: RaceRoadView, road: Road) {
        view.setupRoad(road: road)
    }
    
    private func setupBindings() {
        [firstRoadView, secondRoadView, thirdRoadView].forEach { roadView in
            roadView.selectEvent
                .bind(to: roadSubject)
                .disposed(by: disposeBag)
        }
    }
}

class RaceRoadView: CHView {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let statsImageView = UIImageView()
    
    private let arrowImageContainer = UIView()
    
    private let roadImageView = UIImageView()
    
    private let rightArrowImageView = UIImageView()
    
    private let arrowImageView = UIImageView()
    
    private let roadLabel = UILabel()
    
    private var road: Road?
    
    private let selectSubject: PublishSubject<Road> = .init()
    var selectEvent: RxObservable<Road> { selectSubject }
    
    private var disposeBag = DisposeBag()
    
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
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(roadImageView)
        containerView.addSubview(arrowImageContainer)
        
        stackView.addArrangedSubview(statsImageView)
        stackView.addArrangedSubview(roadLabel)
        stackView.addArrangedSubview(rightArrowImageView)
        
        arrowImageContainer.addSubview(arrowImageView)
        arrowImageContainer.addSubview(stackView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        roadImageView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        arrowImageContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(roadImageView.snp.top)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-2)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        [statsImageView, rightArrowImageView].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(12)
            }
        }
    }
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(spacing: 2)
        
        statsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.roadStats))
        
        rightArrowImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.chevronRight))
        
        roadLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .caption1))
            .set(textAlignment: .center)
            .set(textColor: .white)
        
        roadImageView.customizer
            .set(contentMode: .scaleToFill)
        
        arrowImageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        roadLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func setupRoad(road: Road) {
        let isUnknown = road.roadType == .unknown
        
        let unknownRoadImage = UIImage(named: "road_type_unknown")
        let roadImage = UIImage(named: "road_type")
        arrowImageView.contentMode = .scaleToFill
        arrowImageView.image = isUnknown ? unknownRoadImage: roadImage
        
        let unknownFont = CHFont(font: .poppinsSemiBold, style: .caption1)
        let roadFont = CHFont(font: .poppinsBold, style: .caption1)
        let font = isUnknown ? unknownFont: roadFont
        roadLabel.font = font.uiFont
        roadLabel.text = road.roadType.prepareRoadTitle
        
        roadImageView.image = road.roadType.image
        roadImageView.contentMode = .scaleToFill
        statsImageView.isHidden = isUnknown
        rightArrowImageView.isHidden = isUnknown
        
        stackView.snp.remakeConstraints {
            $0.centerY.equalToSuperview().offset(-2)
            $0.leading.equalToSuperview().offset(road.roadType == .unknown ? 16: 10)
            $0.trailing.equalToSuperview().offset(road.roadType == .unknown ? -10: -5)
        }
        
        layoutIfNeeded()
        
        disposeBag = DisposeBag()
        disposeBag.insert([
//            self.rx.tapGesture().when(.recognized)
//                .filter { _ in road.roadType != .unknown }
//                .map { _ in road }
//                .bind(to: selectSubject)
        ])
    }
}
