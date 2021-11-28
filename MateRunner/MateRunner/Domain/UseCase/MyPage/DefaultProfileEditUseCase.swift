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

        self.firestoreRepository.fetchUserProfile(of: nickname)
            .subscribe(onNext: { [weak self] userProfile in
                self?.height.onNext(userProfile.height)
                self?.weight.onNext(userProfile.weight)
                self?.imageURL.onNext(userProfile.image)
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveUserInfo(imageData: Data) {
        guard let nickname = self.nickname,
              let height = try? self.height.value(),
              let weight = try? self.weight.value(),
              let imageURL = try? self.imageURL.value() else { return }
        
        let userProfile = UserProfile(
            image: imageURL,
            height: height,
            weight: weight
        )
        
        self.firestoreRepository.saveAll(
            userProfile: userProfile,
            with: imageData,
            of: nickname
        )
            .subscribe(onNext: {
                self.saveResult.onNext(true)
                self.cacheNewImage(data: imageData)
            })
            .disposed(by: self.disposeBag)
    }
    
    func cacheNewImage(data imageData: Data) {
        guard let nickname = nickname else { return }
        self.firestoreRepository.fetchUserProfile(of: nickname)
            .subscribe(onNext: { profile in
                DefaultImageCacheService.shared.replace(imageData: imageData, of: profile.image)
            })
            .disposed(by: self.disposeBag)
    }
}
