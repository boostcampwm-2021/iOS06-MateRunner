//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let uid: String
    var validText = PublishSubject<String?>()
    var height = BehaviorSubject<Double?>(value: 170)
    var weight = BehaviorSubject<Double?>(value: 60)
    var canSignUp = PublishSubject<Bool>()
    var signUpResult = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    init(
        repository: UserRepository,
        firestoreRepository: FirestoreRepository,
        uid: String
    ) {
        self.userRepository = repository
        self.firestoreRepository = firestoreRepository
        self.uid = uid
    }
    
    func validate(text: String) {
        self.validText.onNext(self.checkValidty(of: text))
    }
    
    private func checkValidty(of nicknameText: String) -> String? {
        guard nicknameText.count <= 20 else { return nil }
        guard nicknameText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil else { return nil }
        return nicknameText
    }
    
    func checkDuplicate(of nickname: String?) {
        guard let nickname = nickname else { return }

        self.userRepository.fetchFCMTokenFromServer(of: nickname)
            .subscribe(onNext: { [weak self] _ in
                self?.canSignUp.onNext(false)
            }, onError: { [weak self] _ in
                self?.canSignUp.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func signUp(nickname: String?) {
        guard let nickname = nickname,
              let height = try? self.height.value(),
              let weight = try? self.weight.value() else { return }
        
        let userData = UserData(
            nickname: nickname,
            image: "",
            time: 0,
            distance: 0.0,
            calorie: 0.0,
            height: height,
            weight: weight,
            mate: []
        )
        
        let saveUserDataResult = self.firestoreRepository.save(user: userData)
        let saveUIDResult = self.firestoreRepository.save(uid: self.uid, nickname: nickname)
        
        Observable.zip(saveUserDataResult, saveUIDResult) { _, _ in }
            .subscribe(onNext: { [weak self] in
                self?.signUpResult.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveFCMToken(of nickname: String?) {
        guard let fcmToken = self.userRepository.fetchFCMToken(),
              let nickname = nickname else { return }

        self.userRepository.saveFCMToken(fcmToken, of: nickname)
            .subscribe(onNext: { [weak self] in
                self?.userRepository.deleteFCMToken()
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveLoginInfo(nickname: String?) {
        guard let nickname = nickname else { return }
        self.userRepository.saveLoginInfo(nickname: nickname)
    }
}
