//
//  BetCarCell.swift
//  chingari
//
//  Created by Sergey Pritula on 24.08.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class BetCarCell: CollectionViewCell {
    
    private let containerView = UIView()
    
    private let topContainerView = UIView()
    
    private let infoButton = UIButton()
    
    private let infoContainerView = UIView()
    
    private let infoLabel = UILabel()
    
    private let carImageView = UIImageView()
    
    private let carLabel = UILabel()
    
    private let diamondsContainerView = UIView()
    
    private let diamondsLabel = UILabel()
    
    private let diamondsIcon = UIImageView()
    
    private let bottomDiamondsView = UIView()
    
    private let bottomBackgroundImageView = UIImageView()
    
    private let bottomDiamondsContainerView = UIView()
    
    private let bottomDiamondsLabel = UILabel()
    
    private let bottomDiamondsIcon = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
//        containerView.addShadow(
//            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.08),
//            offset: .init(width: 0, height: 1),
//            shadowOpacity: 1,
//            shadowRadius: 6
//        )
        
        infoButton.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.infoIcon))
        
        infoContainerView.customizer
            .set(cornerRadius: 6)
            .set(backgroundColor: UIColor(hexString: CarRaceGameConstants.Colors.purple))
        
        infoLabel.customizer
            .set(font: .systemFont(ofSize: 8))
            .set(textColor: .white)
        
        diamondsIcon.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
        
        bottomDiamondsIcon.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
        
        diamondsLabel.customizer
            .set(font: .init(font: .poppinsRegular, style: .caption2))
            .set(textColor: .black)
            .set(minimumScaleFactor: 0.5)
        
        bottomDiamondsLabel.customizer
            .set(font: .init(font: .poppinsRegular, style: .caption2))
            .set(textColor: .white)
            .set(minimumScaleFactor: 0.5)
        
        carLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .caption1))
            .set(textColor: UIColor(hexString: "#2C2334").withAlphaComponent(0.7))
        
        bottomBackgroundImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.orangeBackground))
            .set(contentMode: .scaleToFill)
        
        topContainerView.customizer
            .set(cornerRadius: 10)
            .set(borderWidth: 1)
            .set(borderColor: .white)
            .set(backgroundColor: UIColor(hexString: "#FFF1FF"))
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubviews([topContainerView, bottomDiamondsView])
        
        topContainerView.addSubviews([infoButton, infoContainerView, carImageView, carLabel, diamondsContainerView])
        bottomDiamondsView.addSubviews([bottomBackgroundImageView, bottomDiamondsContainerView])
        
        diamondsContainerView.addSubviews([diamondsLabel, diamondsIcon])
        bottomDiamondsContainerView.addSubviews([bottomDiamondsLabel, bottomDiamondsIcon])
        
        infoContainerView.addSubview(infoLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topContainerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(bottomDiamondsView.snp.top).offset(13)
        }
        
        bottomDiamondsView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        bottomBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomDiamondsContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        bottomDiamondsIcon.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        bottomDiamondsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        infoContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(6)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        }
        
        infoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(infoContainerView)
            $0.width.height.equalTo(12)
        }
        
        carLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(diamondsContainerView.snp.top).offset(-8)
        }
        
        carImageView.snp.makeConstraints {
            $0.width.height.equalTo(65)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        diamondsContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        diamondsIcon.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        diamondsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func render(with model: BetCarCellViewModel) {
        carLabel.text = model.carBet.car.name
        diamondsLabel.text = String(Int(model.carBet.totalBetAmount))
        infoLabel.text = "\(model.carBet.dynamicOdds)/\(model.carBet.car.standartOdds)"
        
        carImageView.image = nil
        if let url = URL(string: model.carBet.car.iconFrontThumb) {
            carImageView.sd_setImage(with: url)
        }
        
       setupBindings(for: model)
    }
    
    private func setupBindings(for model: BetCarCellViewModel) {
        disposeBag.insert([
            setupSelectedObserver(signal: model.isSelectedRelay.asObservable()),
            setupPlacedBetObserver(signal: model.placedBetRelay.asObservable())
        ])
    }
    
    private func setupSelectedObserver(signal: RxObservable<Bool>) -> Disposable {
        signal.subscribe(onNext: { [weak self] isSelected in
            let color = isSelected ? UIColor(hexString: "#FFB872"): UIColor.white
            self?.topContainerView.layer.borderColor = color.cgColor
        })
    }
    
    private func setupCurrentBetObserving(signal: RxObservable<Int?>) -> Disposable {
        signal.subscribe(onNext: { [weak self] currentBet in
            self?.bottomDiamondsLabel.text = String(currentBet ?? 0)
        })
    }
    
    private func setupPlacedBetObserver(signal: RxObservable<Int>) -> Disposable {
        signal.subscribe(onNext: { [weak self] placedBet in
            self?.bottomDiamondsLabel.text = String(placedBet)
        })
    }
    
}
