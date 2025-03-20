//
//  NotificationCenter+KeyboardHeight.swift
//  Extensions
//
//  Created by Vorko Dmitriy on 02.06.2021.
//

import UIKit
import RxSwift

internal extension Reactive where Base: NotificationCenter {
    func keyboardHeightNotifier(key: String = UIResponder.keyboardFrameBeginUserInfoKey) -> RxObservable<CGFloat> {
        let notificationCenter = NotificationCenter.default
        return RxObservable
            .from([
                notificationCenter.rx.notification(UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGFloat in
                        guard
                            let userInfo = notification.userInfo,
                            let keyboardFrameValue = userInfo[key] as? NSValue
                        else {
                            return 0
                        }
                        let keyboardFrame = keyboardFrameValue.cgRectValue
                        return keyboardFrame.height
                    },

                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .map { _ -> CGFloat in
                        0
                    }
            ])
            .merge()
    }
}
