//
//  RunningRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import RxSwift

protocol RunningRepository {
    func listen(sessionId: String, mate: String) -> Observable<RunningRealTimeData>
    func listenIsCancelled(of sessionId: String) -> Observable<Bool>
    func saveRunningRealTimeData(_ domain: RunningRealTimeData, sessionId: String, user: String) -> Observable<Void>
    func cancelSession(of runningSetting: RunningSetting) -> Observable<Void>
    func stopListen(sessionId: String, mate: String)
    func saveRunningStatus(of user: String, isRunning: Bool) -> Observable<Void>
    func fetchRunningStatus(of mate: String) -> Observable<Bool>
}
