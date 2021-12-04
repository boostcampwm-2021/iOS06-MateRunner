//
//  MockSignUpUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import Foundation

import RxSwift

final class MockSignUpUseCase: SignUpUseCase {
    var nickname: String = ""
    var selectedProfileEmoji = BehaviorSubject<String>(value: "👩🏻‍🚀")
    var nicknameValidationState = BehaviorSubject<SignUpValidationState>(value: .empty)
    var height = BehaviorSubject<Double>(value: 170)
    var weight = BehaviorSubject<Double>(value: 60)
    
    func validate(text: String) {
        self.nickname = text
        self.updateValidationState(of: text)
    }
    
    func signUp() -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func saveLoginInfo() {
        
    }
    
    func shuffleProfileEmoji() {
        self.selectedProfileEmoji.onNext(self.createRandomEmoji())
    }
    
    private func createRandomEmoji() -> String {
        let emojis = [UInt32](0x1F601...0x1F64F).compactMap { UnicodeScalar($0)?.description }
        return emojis.randomElement() ?? "👩🏻‍🚀"
    }
    
    private func updateValidationState(of nicknameText: String) {
        guard !nicknameText.isEmpty else {
            self.nicknameValidationState.onNext(.empty)
            return
        }
        guard nicknameText.count >= 5 else {
            self.nicknameValidationState.onNext(.lowerboundViolated)
            return
        }
        guard nicknameText.count <= 20 else {
            self.nicknameValidationState.onNext(.upperboundViolated)
            return
        }
        guard nicknameText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil else {
            self.nicknameValidationState.onNext(.invalidLetterIncluded)
            return
        }
        
        self.nicknameValidationState.onNext(.success)
    }
}
