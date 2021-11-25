//
//  DefaultProfileEditUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

final class DefaultProfileEditUseCase: ProfileEditUseCase {
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    var height = BehaviorSubject<Int?>(value: nil)
    var weight = BehaviorSubject<Int?>(value: nil)
    var nickname = BehaviorSubject<String>(value: "")
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getCurrentHeight() {
        guard let currentHeight = try? self.height.value() else { return }
        self.height.onNext(currentHeight)
    }
    
    func getCurrentWeight() {
        guard let currentWeight = try? self.weight.value() else { return }
        self.weight.onNext(currentWeight)
    }
    
    func loadUserInfo() {
        self.height.onNext(175)
        self.weight.onNext(65)
        self.nickname.onNext(self.userRepository.fetchUserNickname() ?? "")
    }
}
