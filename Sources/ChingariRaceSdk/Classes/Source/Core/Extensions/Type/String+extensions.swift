//
//  StringExtensions.swift
//  MVVM-C & RxSwift Template
//
//  Created by K7 Tech Agency
//  Copyright © 2019 Nikola Milic. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        count
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
    
    func toUrl() -> URL? {
        return URL(string: self)
    }
    
}
