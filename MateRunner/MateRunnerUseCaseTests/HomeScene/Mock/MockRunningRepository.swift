//
//  MockRunningRepository.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockRunningRepository: RunningRepository {
    func listen(sessionId: String, mate: String) -> Observable<RunningRealTimeData> {
        return Observable.of(RunningRealTimeData(elapsedDistance: 1, elapsedTime: 1))
    }
    
    func listenIsCancelled(of sessionId: String) -> Observable<Bool> {
        return sessionId == "canceled" ? Observable.of(true) : Observable.of(false)
    }
    
    func saveRunningRealTimeData(_ domain: RunningRealTimeData, sessionId: String, user: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func cancelSession(of runningSetting: RunningSetting) -> Observable<Void> {
        return Observable.just(())
    }
    
    func stopListen(sessionId: String, mate: String) {}
    
    func saveRunningStatus(of user: String, isRunning: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchRunningStatus(of mate: String) -> Observable<Bool> {
        return mate == "fail" ? Observable.of(true) : Observable.of(false)
    }
    
}
