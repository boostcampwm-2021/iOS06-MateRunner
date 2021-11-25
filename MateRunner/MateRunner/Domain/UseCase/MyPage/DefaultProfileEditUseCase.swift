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
    var saveResult = PublishSubject<Bool>()
    
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
            .subscribe(onNext: { userData in
                self.userData = userData
                self.height.onNext(userData.height)
                self.weight.onNext(userData.weight)
                self.imageURL.onNext(userData.image)
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveUserInfo() {
        guard let height = try? self.height.value(),
              let weight = try? self.weight.value(),
              let userData = self.userData else { return }
        
        let newUserData = UserData(
            nickname: userData.nickname,
            image: userData.image,
            time: userData.time,
            distance: userData.distance,
            calorie: userData.calorie,
            height: height,
            weight: weight,
            mate: userData.mate
        )
        
        self.firestoreRepository.save(user: newUserData)
            .map { true }
            .bind(to: self.saveResult)
            .disposed(by: self.disposeBag)
    }
}
