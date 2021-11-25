//
//  MateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import Foundation

import RxSwift

protocol MateRepository {
    func sendRequestMate(from sender: String, fcmToken: String) -> Observable<Void> 
    func fetchFCMToken(of mate: String)-> Observable<String>
//    func saveRequestMate(_ notice: Notice?) -> Observable<Void> //TODO: saveRequestMate RestAPI로 변경
}
