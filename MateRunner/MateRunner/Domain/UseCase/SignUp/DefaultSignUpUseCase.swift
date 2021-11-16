//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    var validText = PublishSubject<String?>()
    var height: BehaviorSubject<Int> = BehaviorSubject(value: 170)
    var weight: BehaviorSubject<Int> = BehaviorSubject(value: 60)
    
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
}
