//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    private let repository: UserRepository
    private let uid: String
    var validText = PublishSubject<String?>()
    var height: BehaviorSubject<Int> = BehaviorSubject(value: 170)
    var weight: BehaviorSubject<Int> = BehaviorSubject(value: 60)
    var canSignUp = PublishSubject<Bool>()
    var signUpResult = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    init(repository: UserRepository, uid: String) {
        self.repository = repository
        self.uid = uid
    }
    
    func validate(text: String) {
        self.validText.onNext(self.checkValidty(of: text))
    }
    
    private func checkValidty(of nicknameText: String) -> String? {
        guard nicknameText.count <= 20 else { return nil }
        guard nicknameText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil else { return nil }
        return nicknameText
    }
    
    func getCurrentHeight() {
        guard let currentHeight = try? self.height.value() else { return }
        self.height.onNext(currentHeight)
    }
    
    func getCurrentWeight() {
        guard let currentWeight = try? self.weight.value() else { return }
        self.weight.onNext(currentWeight)
    }
    
    func checkDuplicate(of nickname: String?) {
        guard let nickname = nickname else { return }
        self.repository.checkDuplicate(of: nickname)
            .map { !$0 }
            .bind(to: self.canSignUp)
            .disposed(by: self.disposeBag)
    }
    
    func signUp(nickname: String?) {
        guard let nickname = nickname,
              let height = try? self.height.value(),
              let weight = try? self.weight.value() else { return }
        
        self.repository.saveUserInfo(uid: self.uid, nickname: nickname, height: height, weight: weight)
            .bind(to: self.signUpResult)
            .disposed(by: self.disposeBag)
    }
    
    func saveLoginInfo(nickname: String?) {
        guard let nickname = nickname else { return }
        self.repository.saveLoginInfo(nickname: nickname)
    }
}
