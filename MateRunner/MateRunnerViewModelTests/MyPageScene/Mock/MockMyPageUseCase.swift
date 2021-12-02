//
//  MockMyPageUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockMyPageUseCase: MyPageUseCase {
    var nickname: String?
    var imageURL: PublishSubject<String>
    
    init() {
        self.nickname = "materunner"
        self.imageURL = PublishSubject()
    }
    
    func loadUserInfo() {
        self.imageURL.onNext("materunner-profile.png")
    }
    
    func logout() {
        self.nickname = nil
    }
    
    func deleteUserData() -> Observable<Bool> {
        return Observable.just(true)
    }
}
