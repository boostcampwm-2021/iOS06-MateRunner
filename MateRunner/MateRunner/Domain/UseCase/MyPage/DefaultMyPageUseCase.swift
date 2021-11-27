//
//  DefaultMyPageUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxSwift

final class DefaultMyPageUseCase: MyPageUseCase {
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()

    var nickname: String?
    var isNotificationOn = PublishSubject<Bool>()
    var imageURL = PublishSubject<String>()
    
    init(userRepository: UserRepository, firestoreRepository: FirestoreRepository) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
        self.nickname = userRepository.fetchUserNickname()
    }
    
    func loadUserInfo() {
        guard let nickname = self.nickname else { return }
        self.firestoreRepository.fetchUserData(of: nickname)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] userData in
                self?.imageURL.onNext(userData.image)
            })
            .disposed(by: self.disposeBag)
    }
}
