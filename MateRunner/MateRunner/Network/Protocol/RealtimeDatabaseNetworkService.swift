//
//  RealtimeDatabaseNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/17.
//

import Foundation

import RxSwift

protocol RealtimeDatabaseNetworkService {
    func updateChildValues(with value: [String: Any], path: [String]) -> Observable<Void>
    func update(with: Any, path: [String]) -> Observable<Void>
    func listen(path: [String]) -> Observable<FirebaseDictionary>
    func stopListen(path: [String])
    func fetch(of path: [String])-> Observable<FirebaseDictionary>
    func fetchNotificationState(of mate: String) -> Observable<Bool>
    func fetchFCMToken(of mate: String)-> Observable<String>
}
