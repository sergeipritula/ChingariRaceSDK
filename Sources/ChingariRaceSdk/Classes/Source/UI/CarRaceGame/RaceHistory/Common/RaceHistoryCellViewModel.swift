//
//  RaceHistoryCellViewModel.swift
//  chingari
//
//  Created by Sergey Pritula on 16.09.2024.
//  Copyright © 2024 Nikola Milic. All rights reserved.
//

import UIKit

class RaceHistoryCellViewModel {
    let id: String
    let time: String
    let winners: String
    let imageUrl: String
    let prizes: String
    
    init(with model: ChingariRaceHistoryDTO) {
        self.id = model.sessionId
        self.time = model.sessionTime
        self.winners = "\(model.winnersCount)"
        self.imageUrl = model.result.iconFrontThumb
        self.prizes = "\(model.prizes)"
    }
    
    init(with model: ChingariRaceMyHistoryDTO) {
        self.id = model.sessionId
        self.time = model.sessionTime
        self.winners = "\(model.mySpend)"
        self.imageUrl = model.result.iconFrontThumb
        self.prizes = "\(model.myPrizes)"
    }
    
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: time) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                return timeFormatter.string(from: date)
            } else {
                let fullFormatter = DateFormatter()
                fullFormatter.dateFormat = "MM.dd HH:mm"
                return fullFormatter.string(from: date)
            }
        } else {
            return ""
        }
    }

}
