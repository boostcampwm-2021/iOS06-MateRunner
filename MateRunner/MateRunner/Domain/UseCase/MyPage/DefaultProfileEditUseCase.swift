//
//  DefaultProfileEditUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

final class DefaultProfileEditUseCase: ProfileEditUseCase {
    private let firestoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()
    private var userData: UserData?
    
    var nickname: String?
    var height = BehaviorSubject<Double?>(value: nil)
    var weight = BehaviorSubject<Double?>(value: nil)
    var imageURL = BehaviorSubject<String?>(value: nil)
    
    init(firestoreRepository: FirestoreRepository, with nickname: String?) {
        self.firestoreRepository = firestoreRepository
        self.nickname = nickname
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
        guard let nickname = self.nickname else { return }

        self.firestoreRepository.fetchUserData(of: nickname)
            .compactMap { $0 }
            .debug()
            .subscribe(onNext: { userData in
                self.userData = userData
                self.height.onNext(userData.height)
                self.weight.onNext(userData.weight)
                self.imageURL.onNext(userData.image)
            })
            .disposed(by: self.disposeBag)
    }
}
