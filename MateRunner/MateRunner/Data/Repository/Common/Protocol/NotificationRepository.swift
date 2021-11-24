//
//  NotificationRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

protocol NotificationRepository {
    func fetchNotificationState(of user: String) -> Observable<Bool>
    func saveNotificationState(of user: String, isOn: Bool) -> Observable<Void>
}
