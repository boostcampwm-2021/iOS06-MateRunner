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
    private let disposeBag = DisposeBag()
    var isNotificationOn = PublishSubject<Bool>()
    var nickname: String?
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.nickname = userRepository.fetchUserNickname()
    }
}
