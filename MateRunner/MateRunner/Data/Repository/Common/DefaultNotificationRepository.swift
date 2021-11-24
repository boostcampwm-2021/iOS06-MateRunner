//
//  DefaultNotificationRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

final class DefaultNotificationRepository: NotificationRepository {
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService

    init(realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService) {
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
    }
    
    func fetchNotificationState(of user: String) -> Observable<Bool> {
        return self.realtimeDatabaseNetworkService.fetchNotificationState(of: user)
    }
    
    func saveNotificationState(of user: String, isOn: Bool) -> Observable<Void> {
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: ["isOn": isOn],
            path: ["notification", "\(user)"]
        )
    }
}
