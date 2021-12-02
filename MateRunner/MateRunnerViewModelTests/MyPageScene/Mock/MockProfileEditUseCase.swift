//
//  MockProfileEditUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockProfileEditUseCase: ProfileEditUseCase {
    var nickname: String?
    var height: BehaviorSubject<Double?>
    var weight: BehaviorSubject<Double?>
    var imageURL: BehaviorSubject<String?>
    var saveResult: PublishSubject<Bool>
    
    init() {
        self.nickname = ""
        self.height = BehaviorSubject(value: 170.0)
        self.weight = BehaviorSubject(value: 60.0)
        self.imageURL = BehaviorSubject(value: "image.png")
        self.saveResult = PublishSubject()
    }
    
    func loadUserInfo() {
        self.nickname = "materunner"
        self.height.onNext(160.0)
        self.weight.onNext(50.0)
        self.imageURL.onNext("materunner.png")
    }
    
    func saveUserInfo(imageData: Data) {
        self.saveResult.onNext(true)
    }
}
