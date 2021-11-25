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
    
    var nickname: String?
    var height = BehaviorSubject<Double?>(value: nil)
    var weight = BehaviorSubject<Double?>(value: nil)
    var imageURL = BehaviorSubject<String?>(value: nil)
    var saveResult = PublishSubject<Bool>()
    
    init(firestoreRepository: FirestoreRepository, with nickname: String?) {
        self.firestoreRepository = firestoreRepository
        self.nickname = nickname
    }
    
    func loadUserInfo() {
        guard let nickname = self.nickname else { return }

        self.firestoreRepository.fetchUserData(of: nickname)
            .compactMap { $0 }
            .subscribe(onNext: { userData in
                self.height.onNext(userData.height)
                self.weight.onNext(userData.weight)
                self.imageURL.onNext(userData.image)
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveUserInfo() {
        guard let nickname = self.nickname,
              let height = try? self.height.value(),
              let weight = try? self.weight.value(),
              let imageURL = try? self.imageURL.value() else { return }
        
        let userProfile = UserProfile(
            image: imageURL,
            height: height,
            weight: weight
        )
        
        self.firestoreRepository.save(userProfile: userProfile, of: nickname)
            .map { true }
            .bind(to: self.saveResult)
            .disposed(by: self.disposeBag)
    }
}
