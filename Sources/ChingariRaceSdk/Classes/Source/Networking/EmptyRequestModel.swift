//
//  EmptyRequestModel.swift
//  chingari
//
//  Created by Aleksandr Vdovichenko on 01-12-2021.
//  Copyright © 2021 Nikola Milic. All rights reserved.
//

import Foundation

class EmptyRequestModel: Codable, Equatable {
    
    static func ==(lhs: EmptyRequestModel, rhs: EmptyRequestModel) -> Bool {
        return true
    }
    
    init() {
        
    }
}
