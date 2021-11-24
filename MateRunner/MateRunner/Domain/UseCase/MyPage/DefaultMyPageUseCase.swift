//
//  DefaultMyPageUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import UIKit

import RxSwift

final class DefaultMyPageUseCase: MyPageUseCase {
    private let userRepository: UserRepository
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    var isNotificationOn: PublishSubject<Bool> = PublishSubject<Bool>()
    
    init(userRepository: UserRepository, notificationRepository: NotificationRepository) {
        self.userRepository = userRepository
        self.notificationRepository = notificationRepository
    }
    
    func checkNotificationState() {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        self.notificationRepository.fetchNotificationState(of: userNickname)
            .subscribe(onNext: { [weak self] isOn in
                self?.isNotificationOn.onNext(isOn)
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateNotificationState(isOn: Bool) {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        self.notificationRepository.saveNotificationState(of: userNickname, isOn: isOn)
            .subscribe(onNext: { [weak self] in
                self?.isNotificationOn.onNext(isOn)
            })
            .disposed(by: self.disposeBag)
    }
}
