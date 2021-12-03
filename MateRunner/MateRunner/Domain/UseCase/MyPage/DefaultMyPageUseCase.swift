//
//  DefaultMyPageUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxSwift

final class DefaultMyPageUseCase: MyPageUseCase {
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()

    var nickname: String?
    var imageURL = PublishSubject<String>()
    
    init(userRepository: UserRepository, firestoreRepository: FirestoreRepository) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
        self.nickname = userRepository.fetchUserNickname()
    }
    
    func loadUserInfo() {
        guard let nickname = self.nickname else { return }
        self.firestoreRepository.fetchUserData(of: nickname)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] userData in
                self?.imageURL.onNext(userData.image)
            })
            .disposed(by: self.disposeBag)
    }
    
    func logout() {
        self.userRepository.saveLogoutInfo()
    }
    
    func deleteUserData() -> Observable<Bool> {
        self.userRepository.deleteUserInfo()
        guard let nickname = self.nickname else { return Observable.just(false) }

        let removeUserInfoResult = self.firestoreRepository.remove(user: nickname)
        let removeUIDResult = self.firestoreRepository.fetchUID(of: nickname)
            .compactMap { $0 }
            .flatMap { [weak self] uid in
                self?.firestoreRepository.removeUID(uid: uid) ?? Observable.just(())
            }
        
        return Observable.zip(
            removeUserInfoResult,
            removeUIDResult
        ) { (_, _) in
            return true
        }
    }

}
