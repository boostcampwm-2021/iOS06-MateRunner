//
//  DefaultSignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

enum SignUpValidationError: Error {
    case nicknameDuplicatedError
    case requiredDataMissingError
    
    var description: String {
        switch self {
        case .nicknameDuplicatedError:
            return "이미 존재하는 닉네임입니다"
        case .requiredDataMissingError:
            return "알 수 없는 에러"
        }
    }
}

enum SignUpValidationState {
    case empty
    case lowerboundViolated
    case upperboundViolated
    case invalidLetterIncluded
    case success
    
    var description: String {
        switch self {
        case .empty, .success:
            return ""
        case .lowerboundViolated:
            return "최소 5자 이상 입력해주세요"
        case .upperboundViolated:
            return "최대 20자까지만 가능해요"
        case .invalidLetterIncluded:
            return "영문과 숫자만 입력할 수 있어요"
        }
    }
}

final class DefaultSignUpUseCase: SignUpUseCase {
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let uid: String
    var nickname: String = ""
    var selectedProfileEmoji = BehaviorSubject<String>(value: "👩🏻‍🚀")
    var nicknameValidationState = BehaviorSubject<SignUpValidationState>(value: .empty)
    var height = BehaviorSubject<Double>(value: 170)
    var weight = BehaviorSubject<Double>(value: 60)
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
        self.nickname = text
        self.updateValidationState(of: text)
    }
    
    func signUp() -> Observable<Bool> {
        return self.checkDuplicate(of: self.nickname)
            .flatMap({ [weak self] isDuplicated -> Observable<Bool> in
                guard let self = self else {
                    throw SignUpValidationError.requiredDataMissingError
                }
                guard isDuplicated == false else {
                    throw SignUpValidationError.nicknameDuplicatedError
                }
                
                return self.signUpUser()
            })
    }
    
    func saveLoginInfo() {
        self.userRepository.saveLoginInfo(nickname: self.nickname)
    }
    
    func shuffleProfileEmoji() {
        self.selectedProfileEmoji.onNext(self.createRandomEmoji())
    }
    
    private func checkDuplicate(of nickname: String) -> Observable<Bool> {
        
        return self.userRepository.fetchFCMTokenFromServer(of: nickname)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    private func signUpUser() -> Observable<Bool> {
        guard let height = try? self.height.value(),
              let weight = try? self.weight.value() else {
                  return Observable.error(SignUpValidationError.requiredDataMissingError)
              }
        self.saveFCMToken()
        return self.saveImage().flatMap { [weak self] imageDownloadURL -> Observable<Bool> in
            guard let self = self else { throw SignUpValidationError.requiredDataMissingError  }
            let userData = UserData(nickname: self.nickname, image: imageDownloadURL, height: height, weight: weight)
            return Observable.zip(
                self.firestoreRepository.save(user: userData),
                self.firestoreRepository.save(uid: self.uid, nickname: self.nickname)
            ) { _, _ in }
            .map { true }
            .catchAndReturn(false)
        }
    }
    
    private func updateValidationState(of nicknameText: String) {
        guard !nicknameText.isEmpty else {
            self.nicknameValidationState.onNext(.empty)
            return
        }
        guard nicknameText.count >= 5 else {
            self.nicknameValidationState.onNext(.lowerboundViolated)
            return
        }
        guard nicknameText.count <= 20 else {
            self.nicknameValidationState.onNext(.upperboundViolated)
            return
        }
        guard nicknameText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil else {
            self.nicknameValidationState.onNext(.invalidLetterIncluded)
            return
        }
        self.nicknameValidationState.onNext(.success)
    }
    
    private func saveFCMToken() {
        guard let fcmToken = self.userRepository.fetchFCMToken() else { return }
        
        self.userRepository.saveFCMToken(fcmToken, of: self.nickname)
            .subscribe(onNext: { [weak self] in
                self?.userRepository.deleteFCMToken()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func saveImage() -> Observable<String> {
        guard let emoji = try? self.selectedProfileEmoji.value(),
              let emojiImageData = emoji.emojiToImage() else {
                  return Observable.error(SignUpValidationError.requiredDataMissingError)
              }
        
        return self.firestoreRepository.save(profileImageData: emojiImageData, of: self.nickname)
    }
    
    private func createRandomEmoji() -> String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji ?? "👩🏻‍🚀"
    }
}
