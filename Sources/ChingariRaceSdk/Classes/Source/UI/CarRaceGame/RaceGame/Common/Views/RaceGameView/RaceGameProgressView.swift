//
//  RaceGameProgressView.swift
//  chingari
//
//  Created by Sergey Pritula on 12.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import SDWebImage

class PotholesRoadView: CHView {
    
    private let stackView = UIStackView()
    
    private let firstRoadStackView = UIStackView()
    
    private let secondRoadStackView = UIStackView()
    
    private let thirdRoadStackView = UIStackView()
    
    private let firstLine = UIView()
    
    private let secondLine = UIView()
    
    override func setupView() {
        stackView.customizer
            .set(axis: .vertical)
            .set(spacing: 0)
            .set(distribution: .fillEqually)
        
        [firstRoadStackView, secondRoadStackView, thirdRoadStackView].forEach {
            $0.customizer
                .set(axis: .horizontal)
                .set(spacing: 0)
                .set(distribution: .fillEqually)
        }
        
        [firstLine, secondLine].forEach {
            $0.backgroundColor = .white
        }
    }
    
    override func setupConstraints() {
        addSubview(stackView)
        addSubview(firstLine)
        addSubview(secondLine)
        
        stackView.addArrangedSubview(firstRoadStackView)
        stackView.addArrangedSubview(secondRoadStackView)
        stackView.addArrangedSubview(thirdRoadStackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [firstLine, secondLine].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(2)
            }
        }
        
        firstLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(49)
        }
        
        secondLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-49)
        }
    }
    
    func renderRoad() {
        self.layoutIfNeeded()
        
        var itemsCount = Int(self.frame.width / 25)
        itemsCount = itemsCount == 0 ? 1 : itemsCount
    
        [firstRoadStackView, secondRoadStackView, thirdRoadStackView].forEach {
            $0.removeAllArrangedSubviews()
        }
        
        for i in 0..<itemsCount {
            [firstRoadStackView, secondRoadStackView, thirdRoadStackView].forEach {
                let imageView = UIImageView()
                let imageName = "potholes\(i % 3)"
                imageView.image = UIImage(named: imageName)
                imageView.contentMode = .scaleToFill
                imageView.clipsToBounds = true
                $0.addArrangedSubview(imageView)
            }
        }
    }
}

class RaceGameProgressView: CHView {
    
    private let potholesRoadView = PotholesRoadView()
    
    private let containerView = UIView()
    
    private let containerStackView = UIStackView()
    
    private let lottieContainerView = UIView()
    
    private var lottieAnimationView = LottieAnimationView(name: CarRaceGameConstants.Lottie.trafficLightBanner,
                                                          bundle: .module)
    
    private let topBorderImageView = UIImageView()
    
    private let bottomBorderImageView = UIImageView()
    
    private let roadContainerStackView = UIStackView()
    
    private let startLineImageView = UIImageView()
    
    private let finishLineImageView = UIImageView()
    
    private let roadStackView = UIStackView()
    
    private let firstImageView = UIImageView()
    
    private let secondImageView = UIImageView()
    
    private let thirdImageView = UIImageView()

    private let carPathStackView = UIStackView()
 
    private let firstCarPathView = UIView()
    
    private let firstCarImageView = UIImageView()
    
    private let secondCarPathView = UIView()
    
    private let secondCarImageView = UIImageView()
    
    private let thirdCarPathView = UIView()
    
    private let thirdCarImageView = UIImageView()
    
    private var isAnimationRunning = false
    
    override func setupView() {
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        [startLineImageView, finishLineImageView].forEach {
            $0.contentMode = .scaleToFill
        }
        
        startLineImageView.image = UIImage(named: CarRaceGameConstants.Images.startLine, in: .module, compatibleWith: nil)
        finishLineImageView.image = UIImage(named: CarRaceGameConstants.Images.finishLine, in: .module, compatibleWith: nil)
        
        [topBorderImageView, bottomBorderImageView].forEach {
            $0.image = UIImage(named: CarRaceGameConstants.Images.raceBorder, in: .module, compatibleWith: nil)
            $0.contentMode = .scaleToFill
        }
        
        containerStackView.customizer
            .set(axis: .vertical)
            .set(spacing: 0)
            .set(distribution: .fill)
        
        roadStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 0)
            .set(distribution: .fill)
        
        roadContainerStackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 0)
            .set(distribution: .fill)
        
        carPathStackView.customizer
            .set(axis: .vertical)
            .set(spacing: 0)
            .set(distribution: .fillEqually)
        
        lottieAnimationView.loopMode = .playOnce
        lottieAnimationView.contentMode = .scaleAspectFill
        
        [firstImageView, secondImageView, thirdImageView].forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        firstImageView.image = RoadType.bumpy.imageGame
        secondImageView.image = RoadType.potholes.imageGame
        thirdImageView.image = RoadType.desert.imageGame
        
        potholesRoadView.isHidden = true
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(containerStackView)
        containerView.addSubview(potholesRoadView)
        containerView.addSubview(carPathStackView)
        
        carPathStackView.addArrangedSubview(firstCarPathView)
        carPathStackView.addArrangedSubview(secondCarPathView)
        carPathStackView.addArrangedSubview(thirdCarPathView)
        
        firstCarPathView.addSubview(firstCarImageView)
        secondCarPathView.addSubview(secondCarImageView)
        thirdCarPathView.addSubview(thirdCarImageView)
        
        lottieContainerView.addSubview(lottieAnimationView)
        
        containerStackView.addArrangedSubview(lottieContainerView)
        containerStackView.addArrangedSubview(topBorderImageView)
        containerStackView.addArrangedSubview(roadContainerStackView)
        containerStackView.addArrangedSubview(bottomBorderImageView)
        
        roadContainerStackView.addArrangedSubview(startLineImageView)
        roadContainerStackView.addArrangedSubview(roadStackView)
        roadContainerStackView.addArrangedSubview(finishLineImageView)
        
        roadStackView.addArrangedSubview(firstImageView)
        roadStackView.addArrangedSubview(secondImageView)
        roadStackView.addArrangedSubview(thirdImageView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lottieContainerView.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [topBorderImageView, bottomBorderImageView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(6)
            }
        }
        
        roadContainerStackView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
        carPathStackView.snp.makeConstraints {
            $0.edges.equalTo(roadContainerStackView)
        }
        
        [startLineImageView, finishLineImageView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(16)
            }
        }
        
        roadStackView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
    }
    
    func render(with session: ChingariRaceSession) {
        for i in 0..<session.carBets.count {
            let cars = [firstCarImageView, secondCarImageView, thirdCarImageView]
            
            if let url = URL(string: session.carBets[i].car.iconTop) {
                cars[i].sd_setImage(with: url)
            }
        }
                
        switch session.state {
        case .bet:
            break
        case .startInProgess:
            self.resetCarAnimation()
            self.performStartInProgress(session: session)
        case .gameInProgress:
            self.performGameInProgress(session: session)
            self.isAnimationRunning = true
        case .processingBets:
            self.resetCarAnimation()
            self.lottieAnimationView.stop()
            self.isAnimationRunning = false
        case .result:
            self.resetCarAnimation()
            self.potholesRoadView.isHidden = true
            self.lottieAnimationView.stop()
        }
    }
    
    func performStartInProgress(session: ChingariRaceSession) {
        for i in 0..<session.road.count {
            let roads = [firstImageView, secondImageView, thirdImageView]
            setupRoad(imageView: roads[i], road: session.road[i])
        }
        
        lottieAnimationView.removeFromSuperview()
        lottieAnimationView = LottieAnimationView(name: CarRaceGameConstants.Lottie.trafficLightBanner,
                                                  bundle: .module)
        
        lottieContainerView.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.loopMode = .playOnce
        lottieAnimationView.play()
    }
    
    private func setupRoad(imageView: UIImageView, road: Road) {
        imageView.snp.remakeConstraints {
            $0.width.equalToSuperview().multipliedBy(road.length)
        }
        
        imageView.layoutIfNeeded()
        imageView.image = road.roadType.imageGame
        
        if road.roadType == .potholes {
            imageView.contentMode = .left
        } else {
            imageView.contentMode = .scaleAspectFill
        }
        
        if road.roadType == .potholes {
            potholesRoadView.snp.remakeConstraints {
                $0.edges.equalTo(imageView)
            }
            
            layoutIfNeeded()
            
            potholesRoadView.layoutIfNeeded()
            potholesRoadView.renderRoad()
            potholesRoadView.isHidden = false
        }
    }
    
    func performGameInProgress(session: ChingariRaceSession) {
        lottieAnimationView.removeFromSuperview()
        lottieAnimationView = LottieAnimationView(name: CarRaceGameConstants.Lottie.raceTrack,
                                                  bundle: .module)
        
        lottieContainerView.addSubview(lottieAnimationView)
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        
        for i in 0..<session.road.count {
            let roads = [firstImageView, secondImageView, thirdImageView]
            setupRoad(imageView: roads[i], road: session.road[i])
        }
        
        let renderData = session.result?.renderData ?? []
        let images = [firstCarImageView, secondCarImageView, thirdCarImageView]
        
        let firstTimeLine = renderData.first(where: { $0.carId == session.carBets[0].car.id })?.timeline ?? []
        let secondTimeLine = renderData.first(where: { $0.carId == session.carBets[1].car.id })?.timeline ?? []
        let thirdTimeLine = renderData.first(where: { $0.carId == session.carBets[2].car.id })?.timeline ?? []
        
        let renderDataTimelines = [firstTimeLine, secondTimeLine, thirdTimeLine]
        
        for i in 0..<renderData.count {
            let totalDuration = renderDataTimelines[i].reduce(0) { $0 + $1.duration }
            let duration = totalDuration
            
            startCarAnimation(
                carImageView: images[i],
                duration: Double(duration),
                timeLeft: Double(session.timeLeft),
                totalDuration: Double(session.configuration.durations.gameInProgress),
                timeline: renderDataTimelines[i]
            )
        }
    }
    
    private func removeAllAnimations() {
        self.layer.removeAllAnimations()
    }
    
    private func startCarAnimation(
        carImageView: UIImageView,
        duration: Double,
        timeLeft: Double,
        totalDuration: Double,
        timeline: [Timeline]
    ) {
        self.layoutIfNeeded()
        
        let width = self.frame.width - self.finishLineImageView.frame.width - 50
        let coeficient = Int(timeLeft / totalDuration) > 1 ? 0.0: 1 - (timeLeft / totalDuration)
        let leftDuration = duration * (1 - coeficient)
        
        let firstLength = width * timeline[0].length
        let secondLength = firstLength + (width * timeline[1].length)
        let thirdLength = secondLength + (width * timeline[2].length)
        
        let firstDuration = Double(timeline[0].duration) / duration
        let secondDuration = Double(timeline[1].duration) / duration
        let thirdDuration = Double(timeline[2].duration) / duration
        
        let shouldSkipFirstStep = duration - leftDuration < firstDuration
        let shouldSkipSecondStep = duration - leftDuration < (firstDuration + secondDuration)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                carImageView.snp.remakeConstraints {
                    $0.width.height.equalTo(50)
                    $0.centerY.equalToSuperview()
                    $0.leading.equalToSuperview().offset((width * coeficient) - 42)
                }
                carImageView.superview?.layoutIfNeeded()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            UIView.animateKeyframes(withDuration: leftDuration / 1000, delay: 0, options: []) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: leftDuration / 1000) {
                    carImageView.snp.remakeConstraints {
                        $0.width.height.equalTo(50)
                        $0.centerY.equalToSuperview()
                        $0.leading.equalToSuperview().offset(width)
                    }
                    carImageView.superview?.layoutIfNeeded()
                }
            }
        })
    }
    
    private func resetCarAnimation() {
        [firstCarImageView, secondCarImageView, thirdCarImageView].forEach {
            $0.snp.remakeConstraints {
                $0.width.height.equalTo(50)
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(-42)
            }
            $0.layoutIfNeeded()
        }
    }
}
