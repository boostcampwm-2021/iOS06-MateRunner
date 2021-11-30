//
//  MockUserRepository.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/11/30.
//

@testable import MateRunner
import Foundation

import RxSwift

final class MockUserRepository: UserRepository {
    func fetchFCMToken() -> String? {
        return "Sfewe198scDCLsd"
    }
    
    func fetchFCMTokenFromServer(of nickname: String) -> Observable<String> {
        return Observable.just("Sfewe198scDCLsd")
    }
    
    func saveFCMToken(_ fcmToken: String, of nickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchUserNickname() -> String? {
        return "Sfesdfcxkl2131sd"
    }
    
    func deleteFCMToken() {}
    func saveLoginInfo(nickname: String) {}
    func saveLogoutInfo() {}
    func deleteUserInfo() {}
}
