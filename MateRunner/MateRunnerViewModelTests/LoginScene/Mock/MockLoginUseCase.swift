//
//  MockLoginUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import Foundation

import RxSwift

final class MockLoginUseCase: LoginUseCase {
    var isRegistered = PublishSubject<Bool>()
    var isSaved = PublishSubject<Bool>()
    
    func checkRegistration(uid: String) {
        if uid == "registeredMockUID" {
            self.isRegistered.onNext(true)
        } else {
            self.isRegistered.onNext(false)
        }
    }
    
    func saveLoginInfo(uid: String) {
        self.isSaved.onNext(true)
    }
}
