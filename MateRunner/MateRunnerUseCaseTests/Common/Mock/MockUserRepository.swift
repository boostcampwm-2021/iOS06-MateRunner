//
//  MockUserRepository.swift
//  MateRunnerUseCaseTests
//
//  Created by 이유진 on 2021/11/30.
//

import Foundation

import RxSwift

final class MockUserRepository: UserRepository {
    func fetchFCMToken() -> String? {
        return "Sfewe198scDCLsd"
    }
    
    func fetchFCMTokenFromServer(of nickname: String) -> Observable<String> {
        if nickname == "signUpSuccess" {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        return Observable.just("Sfewe198scDCLsd")
    }
    
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchUserNickname() -> String? {
        return "materunner"
    }
    
    func deleteFCMToken() {}
    func saveLoginInfo(nickname: String) {}
    func saveLogoutInfo() {}
    func deleteUserInfo() {}
}
