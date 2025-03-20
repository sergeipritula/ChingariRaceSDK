//
//  UIScrollView+nearBottom.swift
//  ChingariRaceTest
//
//  Created by Sergey Pritula on 18.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

internal extension Reactive where Base: UIScrollView {
    func nearBottom(edgeOffset: CGFloat = 20) -> Signal<()> {
        return self.contentOffset.asSignal(onErrorSignalWith: .empty())
            .flatMap { _ in
                return self.base.isNearBottomEdge(edgeOffset: edgeOffset)
                    ? .just(())
                    : .empty()
            }
    }
}
