//
//  RaceHistoryHeaderView.swift
//  chingari
//
//  Created by Sergey Pritula on 26.07.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

enum RaceHistoryItem {
    
    case time
    case resule
    case winners(details: String?)
    case prizes
    case total
    case rank
    case spend(details: String?)
    case totalSpend
    case mySpend
    case myPrizes
    
    var title: String {
        switch self {
        case .time: return "Time"
        case .resule: return "Result"
        case .winners: return "Winners"
        case .prizes: return "Prizes"
        case .total: return "Total"
        case .rank: return "Rank"
        case .spend: return "Spend"
        case .totalSpend: return "Total\nSpend"
        case .mySpend: return "My Spend"
        case .myPrizes: return "My Prizes"
        }
    }
    
    var details: String {
        switch self {
        case .winners(let value):
            return value ?? ""
        case .spend(let value):
            return value ?? ""
        default:
            return ""
        }
    }
    
    static var history: [RaceHistoryItem] {
        return [.time, .resule, .winners(details: nil), .prizes]
    }
    
    static func historyDetails(winners: String, carName: String) -> [RaceHistoryItem] {
        return [.rank, .winners(details: winners), .totalSpend, .spend(details: carName), .prizes]
    }
    
    static var myHistory: [RaceHistoryItem] {
        return [.time, .resule, .mySpend, .myPrizes]
    }
    
    func isDetailsLabelHidden(isHistory: Bool) -> Bool {
        switch self {
        case .time, .resule, .rank, .totalSpend, .prizes, .total, .mySpend, .myPrizes:
            return true
        case .winners:
            return isHistory
        case .spend:
            return false
        }
    }
    
    func multiplier(isHistoryDetails: Bool) -> CGFloat {
        if !isHistoryDetails {
            return 1
        }
        
        switch self {
        case .rank:
            return 0.1
        case .winners:
            return 0.3
        case .totalSpend, .prizes, .spend, .mySpend, .myPrizes:
            return 0.2
        default:
            return 1
        }
    }
}

class RaceHistoryHeaderView: CHView {
    
    private let stackView = UIStackView()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor(hexString: "#815EF2")
        
        stackView.customizer
            .set(axis: .horizontal)
            .set(spacing: 0)
            .set(distribution: .fillEqually)
            .set(alignment: .fill)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        render(isOwn: false)
    }
 
    func render(isOwn: Bool) {
        let items = isOwn ? RaceHistoryItem.myHistory : RaceHistoryItem.history
        
        stackView.removeAllArrangedSubviews()
        items.forEach { item in
            let container = UIView()
            
            let label = UILabel()
            let delimetr = UIView()
            
            label.customizer
                .set(text: item.title.uppercased())
                .set(font: .init(font: .poppinsMedium, style: .caption1))
                .set(textColor: .white)
                .set(textAlignment: .center)
                .set(numberOfLines: 0)
            
            delimetr.customizer.set(backgroundColor: UIColor(hexString: "#C4C1C8"))
            
            switch item {
            case .prizes, .myPrizes:
                delimetr.isHidden = true
            default:
                delimetr.isHidden = false
            }
            
            container.addSubview(label)
            container.addSubview(delimetr)
            
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
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
            }
        }
    }
}
