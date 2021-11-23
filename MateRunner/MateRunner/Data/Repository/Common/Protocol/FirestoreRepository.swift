//
//  FirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

import RxSwift

protocol FirestoreRepository {
    func fetchRunningResult(of nickname: String, from: Date?, to: Date?) -> Observable<RunningResult>
    func fetchEmojis(of resultID: String) -> Observable<Emoji>
    func saveRunningResult(runningResult: RunningResult) -> Observable<Void>
    func addEmoji(to mateNickname: String, resultID: String) -> Observable<Void>
    func removeEmoji(from mateNickname: String, resultID: String) -> Observable<Void>
}
