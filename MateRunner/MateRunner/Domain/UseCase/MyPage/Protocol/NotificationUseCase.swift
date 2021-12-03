//
//  NotificationUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

protocol NotificationUseCase {
    var notices: PublishSubject<[Notice]> { get set }
    func fetchNotices()
    func updateMateState(notice: Notice, isAccepted: Bool)
}
