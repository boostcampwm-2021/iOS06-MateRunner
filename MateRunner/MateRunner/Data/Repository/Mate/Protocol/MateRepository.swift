//
//  MateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import Foundation

import RxSwift

protocol MateRepository {
    func fetchMateNickname() -> Observable<[String]>
    func fetchMateProfileImage(from nickname: String) -> Observable<String>
    func fetchFilteredNickname(text: String) -> Observable<[String]>
    func sendRequestMate(from sender: String, fcmToken: String) -> Observable<Void> 
    func fetchFCMToken(of mate: String)-> Observable<String>
    func fetchNotificationState(of mate: String) -> Observable<Bool>
    func saveRequestMate(_ notice: Notice?) -> Observable<Void>
}
