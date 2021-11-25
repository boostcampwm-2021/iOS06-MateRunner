//
//  NotificationViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

final class NotificationViewModel {
    private weak var notificationCoordinator: NotificationCoordinator?
    private let notificationUseCase: NotificationUseCase
    
    init(
        notificationCoordinator: NotificationCoordinator,
        notificationUseCase: NotificationUseCase
    ) {
        self.notificationCoordinator = notificationCoordinator
        self.notificationUseCase = notificationUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
