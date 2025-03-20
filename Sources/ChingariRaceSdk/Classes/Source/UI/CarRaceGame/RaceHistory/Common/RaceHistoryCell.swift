//
//  RaceHistoryCell.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceHistoryCell: TableViewCell {
    
    private let containerView = UIView()
    
    private let stackView = UIStackView()
    
    private let timeContainerView = UIView()
    
    private let timeLabel = UILabel()
    
    private let carContainerView = UIView()
    
    private let carImageView = UIImageView()
    
    private let winnerContainerView = UIView()
    
    private let winnersLabel = UILabel()
    
    private let prizesContainerView = UIView()
    
    private let prizesStakView = UIStackView()
    
    private let diamondsImageView = UIImageView()
    
    private let diamondsLabel = UILabel()
    
    private let arrowImageView = UIImageView()
    
    private let disclosureImageView = UIImageView()
    
    override func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        stackView.customizer
            .set(distribution: .fillEqually)
            .set(axis: .horizontal)
        
        prizesStakView.customizer
            .set(distribution: .fill)
            .set(axis: .horizontal)
            .set(spacing: 3)
        
        diamondsImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.diamond))
        
        disclosureImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.disclosure))
        
        carImageView.customizer
            .set(image: UIImage(named: CarRaceGameConstants.Images.monsterTruckSmall))
            .set(contentMode: .scaleAspectFit)
        
        timeLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption2))
            .set(textColor: UIColor(hexString: "#551C88"))
        
        winnersLabel.customizer
            .set(font: .init(font: .poppinsMedium, style: .caption2))
            .set(textColor: UIColor(hexString: "#551C88"))
        
        diamondsLabel.customizer
            .set(font: .init(font: .poppinsRegular, style: .caption2))
            .set(textColor: UIColor(hexString: "#551C88"))
    }
    
    override func setupConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(stackView)
        containerView.addSubview(disclosureImageView)
        
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(timeContainerView)
        stackView.addArrangedSubview(carContainerView)
        stackView.addArrangedSubview(winnerContainerView)
        stackView.addArrangedSubview(prizesContainerView)
        
        timeContainerView.addSubview(timeLabel)
        carContainerView.addSubview(carImageView)
        winnerContainerView.addSubview(winnersLabel)
        prizesContainerView.addSubview(prizesStakView)
        
        prizesStakView.addArrangedSubview(diamondsImageView)
        prizesStakView.addArrangedSubview(diamondsLabel)
        
        diamondsImageView.snp.makeConstraints {
            $0.size.equalTo(15)
        }
        
        disclosureImageView.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        carImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.center.equalToSuperview()
        }
        
        winnersLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        prizesStakView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func render(index: Int, viewModel: RaceHistoryCellViewModel) {
        if index % 2 == 0 {
            containerView.backgroundColor = UIColor(hexString: "#815EF2").withAlphaComponent(0.04)
        } else {
            containerView.backgroundColor = .clear
        }
        
        carImageView.image = nil
        if let url = URL(string: viewModel.imageUrl) {
            carImageView.sd_setImage(with: url)
        }
        
        timeLabel.text = viewModel.formattedTime
        winnersLabel.text = viewModel.winners
        diamondsLabel.text = viewModel.prizes
    }
}
