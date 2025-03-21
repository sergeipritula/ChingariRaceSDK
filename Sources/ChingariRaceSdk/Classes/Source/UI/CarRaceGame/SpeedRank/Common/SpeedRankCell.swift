//
//  SpeedRankCell.swift
//  chingari
//
//  Created by Sergey Pritula on 25.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpeedRankCell: TableViewCell {
    
    private let backgroundImageView = UIImageView()
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let rankContainer = UIView()
    
    private let rankLabel = UILabel()
    
    private let carImageContainer = UIView()
    
    private let carImageView = UIImageView()
    
    private let carLabelContainer = UIView()
    
    private let carLabel = UILabel()
    
    private let speedContainer = UIView()
    
    private let speedStackView = UIStackView()
    
    private let speedLabel = UILabel()
    
    private let speedImageView = UIImageView()
    
    override func setupView() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView.customizer
            .set(backgroundColor: .white)
            .set(cornerRadius: 8)
        
        containerView.addShadow(
            with: UIColor(hexString: "#3E1A50").withAlphaComponent(0.08),
            offset: .init(width: 0, height: 1),
            shadowOpacity: 1,
            shadowRadius: 6
        )
        
        backgroundImageView.customizer
            .set(contentMode: .scaleToFill)
            .set(image: UIImage(named: CarRaceGameConstants.Images.speedRankBackground, in: .module, compatibleWith: nil))
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(alignment: .center)
        
        speedStackView.customizer
            .set(axis: .horizontal)
            .set(distribution: .fill)
            .set(spacing: 3)
            .set(alignment: .center)
        
        rankLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption1))
            .set(textColor: .black)
            .set(textAlignment: .left)
        
        carLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption1))
            .set(textColor: .black)
            .set(textAlignment: .center)
    
        speedLabel.customizer
            .set(font: .init(font: .poppinsBold, style: .caption2))
            .set(textColor: .black)
        
        speedImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.speedometer, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        carImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.monsterTruckSmall, in: .module, compatibleWith: nil))
            .set(contentMode: .scaleAspectFit)
        
        backgroundImageView.isHidden = arc4random() % 2 == 0
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews([backgroundImageView, stackView])
        
        stackView.addArrangedSubview(rankContainer)
        stackView.addArrangedSubview(carImageContainer)
        stackView.addArrangedSubview(carLabelContainer)
        stackView.addArrangedSubview(speedContainer)
        
        rankContainer.addSubview(rankLabel)
        carImageContainer.addSubview(carImageView)
        carLabelContainer.addSubview(carLabel)
        speedContainer.addSubview(speedStackView)
        
        speedStackView.addArrangedSubview(speedLabel)
        speedStackView.addArrangedSubview(speedImageView)
        
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-4)
            $0.height.equalTo(32)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.bottom.equalToSuperview()
        }
        
        rankContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        
        carImageContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        carLabelContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        speedContainer.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.1)
        }
        
        speedImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
        
        carImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        rankLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        carLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        speedStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func render(with viewModel: SpeedRankCellViewModel) {
        rankLabel.text = String(format: "%02d", viewModel.index)
        carLabel.text = viewModel.model.name
        speedLabel.text = String(viewModel.speed)

        carImageView.image = nil
        if let url = URL(string: viewModel.model.iconFrontThumb) {
            carImageView.sd_setImage(with: url)
        }
        
        backgroundImageView.isHidden = !viewModel.isHighlighted
        
        speedImageView.image = viewModel.isHighlighted ?
            UIImage(named: CarRaceGameConstants.Images.speedometerWhite, in: .module, compatibleWith: nil):
            UIImage(named: CarRaceGameConstants.Images.speedometer, in: .module, compatibleWith: nil)
        
        [rankLabel, carLabel, speedLabel].forEach {
            $0.textColor = viewModel.isHighlighted ? .white : .black
        }
    }
}
