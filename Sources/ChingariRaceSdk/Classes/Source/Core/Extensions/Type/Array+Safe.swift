//
//  Created by Vorko Dmitriy on 12.05.2021.
// Copyright © 2020 com.65apps. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
