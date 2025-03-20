//
//  Created by Vorko Dmitriy on 12.05.2021.
//

import UIKit

public extension CGRect {
    mutating func set(height: CGFloat) {
        self = CGRect(origin: origin, size: .init(width: width, height: height))
    }
}
