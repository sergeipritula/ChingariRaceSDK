//
//  RaceBetCell.swift
//  chingari
//
//  Created by Sergey Pritula on 12.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceBetCell: CollectionViewCell {
    
    private let containerView = UIView()
    
    private let carImageView = UIImageView()
    
    private let diamondsContainerStackView = UIStackView()
    
    private let diamondsStackTopView = UIStackView()
    
    private let diamondsImageTopView = UIImageView()
    
    private let diamondsTopLabel = UILabel()
    
    private let diamondsStackBottomView = UIStackView()
    
    private let diamondsImageBottomView = UIImageView()
    
    private let diamondsBottomLabel = UILabel()
    
    override func setupView() {
        containerView.backgroundColor = UIColor(hexString: "#FFF1FF")
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        
//        containerView.addShadow(
//            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.08),
//            offset: .init(width: 0, height: 1),
//            shadowOpacity: 1,
//            shadowRadius: 6
//        )
        
        diamondsContainerStackView.customizer
            .set(axis: .vertical)
            .set(spacing: 1)
            .set(distribution: .fill)
            .set(alignment: .center)
        
        diamondsStackTopView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        diamondsStackBottomView.customizer
            .set(axis: .horizontal)
            .set(spacing: 2)
            .set(distribution: .fill)
        
        [diamondsTopLabel, diamondsBottomLabel].forEach {
            $0.customizer
                .set(textColor: .black)
                .set(font: .systemFont(ofSize: 8))
        }
        
        [diamondsImageTopView, diamondsImageBottomView].forEach {
            $0.customizer
                .set(image: UIImage(named: CarRaceGameConstants.Images.diamond, in: .module, compatibleWith: nil))
                .set(contentMode: .scaleAspectFit)
        }
    }
    
    override func setupConstraints() {
        addSubview(containerView)
        
        containerView.addSubview(carImageView)
        containerView.addSubview(diamondsContainerStackView)
        
        diamondsContainerStackView.addArrangedSubview(diamondsStackTopView)
        diamondsContainerStackView.addArrangedSubview(diamondsStackBottomView)
        
        diamondsStackTopView.addArrangedSubview(diamondsImageTopView)
        diamondsStackTopView.addArrangedSubview(diamondsTopLabel)
        
        diamondsStackBottomView.addArrangedSubview(diamondsImageBottomView)
        diamondsStackBottomView.addArrangedSubview(diamondsBottomLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        carImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(-6)
            $0.width.equalTo(carImageView.snp.height)
        }
        
        diamondsContainerStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(carImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-6)
        }
        
        [diamondsImageTopView, diamondsImageBottomView].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(10)
            }
        }
        
    }
    
    func render(with model: BetCarCellViewModel) {
        if let url = URL(string: model.carBet.car.iconFrontThumb) {
            carImageView.sd_setImage(with: url)
        }
        
        let totalBets = model.carBet.totalBetAmount
        diamondsTopLabel.text = totalBets == 0 ? "-": String(Int(totalBets))
        diamondsImageTopView.isHidden = totalBets == 0
        
        let placedBets = model.currentBetRelay.value
        diamondsBottomLabel.text = placedBets == 0 ? "-": String(placedBets)
        diamondsImageBottomView.isHidden = placedBets == 0
    }
}
