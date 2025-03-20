//
//  IndexPath+extensions.swift
//  chingari
//
//  Created by Aleksandr Vdovichenko on 28.02.2023.
//  Copyright © 2023 Nikola Milic. All rights reserved.
//

import Foundation

public extension IndexPath {
    
    init(row: Int) {
        self.init(row: row, section: .zero)
    }
    
}
