//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    private enum ValidtaionError: Error {
        case nicknameRuleViolatedError, nicknameDuplicatedError, requiredDataMissingError
    }
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let uid: String
    var selectedProfileEmoji = BehaviorSubject<String>(value: "👩🏻‍🚀")
    var nickname = BehaviorSubject<String>(value: "")
    var height = BehaviorSubject<Double>(value: 170)
    var weight = BehaviorSubject<Double>(value: 60)
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
        self.checkValidty(of: text)
        ? self.nickname.onNext(text)
        : self.nickname.onError(ValidtaionError.nicknameRuleViolatedError)
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.firestoreRepository.fetchUserData(of: nickname)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func signUp() -> Observable<Bool> {
        guard let nickname = try? self.nickname.value(),
              let height = try? self.height.value(),
              let weight = try? self.weight.value() else {
                  return Observable.error(ValidtaionError.requiredDataMissingError)
              }
        
        self.saveFCMToken()
        return self.saveImage().flatMap { [weak self] imageDownloadURL -> Observable<Bool> in
            guard let self = self else { return Observable.error(ValidtaionError.requiredDataMissingError) }
            let userData = UserData(nickname: nickname, image: imageDownloadURL, height: height, weight: weight)
            return Observable.zip(
                self.firestoreRepository.save(user: userData),
                self.firestoreRepository.save(uid: self.uid, nickname: nickname)
            ) { _, _ in }
            .map { true }
            .catchAndReturn(false)
        }
    }
    
    private func checkValidty(of nicknameText: String) -> Bool {
        return nicknameText.count <= 20
        && nicknameText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    private func saveFCMToken() {
        guard let nickname = try? self.nickname.value(),
              let fcmToken = self.userRepository.fetchFCMToken() else { return }

        self.userRepository.saveFCMToken(fcmToken, of: nickname)
            .subscribe(onNext: { [weak self] in
                self?.userRepository.deleteFCMToken()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func saveLoginInfo() {
        guard let nickname = try? self.nickname.value() else { return }
        self.userRepository.saveLoginInfo(nickname: nickname)
    }
    
    private func saveImage() -> Observable<String> {
        guard let nickname = try? self.nickname.value(),
              let emoji = try? self.selectedProfileEmoji.value(),
              let emojiImageData = emoji.emojiToImage() else {
                  return Observable.error(ValidtaionError.requiredDataMissingError)
              }
        
        return self.firestoreRepository.save(profileImageData: emojiImageData, of: nickname)
    }
    
    private func createRandomEmoji() -> String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji ?? "👩🏻‍🚀"
    }
}
