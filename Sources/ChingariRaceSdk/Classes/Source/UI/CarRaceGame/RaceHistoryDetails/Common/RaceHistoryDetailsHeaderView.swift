//
//  RaceHistoryDetailsHeaderView.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceHistoryDetailsHeaderView: CHView {
    
    private let stackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor(hexString: "#815EF2")
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 0)
            .set(distribution: .fill)
            .set(alignment: .fill)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        RaceHistoryItem.historyDetails(winners: "", carName: "").forEach { item in
            let container = UIView()
            
            let containerStackView = UIStackView(axis: .vertical)
            let label = UILabel()
            let detailsLabel = UILabel()
            let delimetr = UIView()
            
            containerStackView.customizer
                .set(spacing: 2)
                .set(distribution: .fill)
            
            label.customizer
                .set(text: item.title)
                .set(font: .init(font: .poppinsSemiBold, style: .caption1))
                .set(textColor: .white)
                .set(textAlignment: .center)
                .set(numberOfLines: 0)
            
            detailsLabel.customizer
                .set(text: item.details)
                .set(font: .init(font: .poppinsRegular, style: .caption2))
                .set(textColor: UIColor(hexString: "#E7CFEE"))
                .set(textAlignment: .center)
                .set(numberOfLines: 0)
                .set(isHidden: item.isDetailsLabelHidden(isHistory: false))
            
            delimetr.customizer.set(backgroundColor: UIColor(hexString: "#C4C1C8"))
            
            switch item {
            case .prizes:
                delimetr.isHidden = true
            default:
                delimetr.isHidden = false
            }
            
            container.addSubview(containerStackView)
            container.addSubview(delimetr)
            containerStackView.addArrangedSubview(label)
            containerStackView.addArrangedSubview(detailsLabel)
            
            containerStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            delimetr.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(1)
                $0.height.equalToSuperview()
            }
            
            stackView.addArrangedSubview(container)
            
            container.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(item.multiplier(isHistoryDetails: true))
            }
        }
    }
    
    func render(winners: String, carName: String) {
        stackView.removeAllArrangedSubviews()
        RaceHistoryItem.historyDetails(winners: winners, carName: carName).forEach { item in
            let container = UIView()
            
            let containerStackView = UIStackView(axis: .vertical)
            let label = UILabel()
            let detailsLabel = UILabel()
            let delimetr = UIView()
            
            containerStackView.customizer
                .set(spacing: 2)
                .set(distribution: .fill)
            
            label.customizer
                .set(text: item.title.uppercased())
                .set(font: .init(font: .poppinsSemiBold, style: .caption1))
                .set(textColor: .white)
                .set(textAlignment: .center)
                .set(numberOfLines: 0)
            
            detailsLabel.customizer
                .set(text: item.details)
                .set(font: .init(font: .poppinsRegular, style: .caption2))
                .set(textColor: UIColor(hexString: "#E7CFEE"))
                .set(textAlignment: .center)
                .set(numberOfLines: 0)
                .set(isHidden: item.isDetailsLabelHidden(isHistory: false))
            
            delimetr.customizer.set(backgroundColor: UIColor(hexString: "#C4C1C8"))
            
            switch item {
            case .prizes:
                delimetr.isHidden = true
            default:
                delimetr.isHidden = false
            }
            
            container.addSubview(containerStackView)
            container.addSubview(delimetr)
            containerStackView.addArrangedSubview(label)
            containerStackView.addArrangedSubview(detailsLabel)
            
            containerStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            delimetr.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(1)
                $0.height.equalToSuperview()
            }
            
            stackView.addArrangedSubview(container)
            
            container.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(item.multiplier(isHistoryDetails: true))
            }
        }
    }
}
