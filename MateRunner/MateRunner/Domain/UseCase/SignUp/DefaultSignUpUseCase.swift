//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    var height: BehaviorSubject<Int> = BehaviorSubject(value: 170)
    
    func getCurrentHeight() {
        guard let currentHeight = try? self.height.value() else { return }
        self.height.onNext(currentHeight)
    }
}
