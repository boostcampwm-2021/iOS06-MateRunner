//
//  UIScrollView+ObserveScroll.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/29.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIScrollView {
    func endToScroll() -> ControlEvent<Void> {
        return ControlEvent( events: contentOffset.map { offset in
            let offsetY = offset.y
            let contentHeight = self.base.contentSize.height
            let height = self.base.frame.height
            
            return offsetY > (contentHeight - height)
        }
        .filter { $0 }
        .map { _ in () }
        )
    }
}
