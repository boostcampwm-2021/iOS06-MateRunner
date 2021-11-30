//
//  DefaultRunningRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import Firebase
import RxRelay
import RxSwift

enum MockError: Error {
    case unknown
}

final class DefaultRunningRepository: RunningRepository {
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    
    init(realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService) {
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
    }
    
    func listen(sessionId: String, mate: String) -> Observable<RunningRealTimeData> {
        return self.realtimeDatabaseNetworkService.listen(path: [RealtimeDatabaseKey.session, sessionId, mate])
            .map { data in
                guard let distance = data[RealtimeDatabaseKey.elapsedDistance] as? Double,
                      let time = data[RealtimeDatabaseKey.elapsedTime] as? Int else {
                          return RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
                      }
                return RunningRealTimeData(elapsedDistance: distance, elapsedTime: time)
            }
    }
    
    func listenIsCancelled(of sessionId: String) -> Observable<Bool> {
        return self.realtimeDatabaseNetworkService.listen(path: [RealtimeDatabaseKey.session, sessionId])
            .map { data in
                guard let isCancelled = data[RealtimeDatabaseKey.isCancelled] as? Bool else {
                    return false
                }
                return isCancelled
            }
    }
    
    func saveRunningRealTimeData(_ domain: RunningRealTimeData, sessionId: String, user: String) -> Observable<Void> {
        guard let data = try? JSONEncoder.init().encode(domain),
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.realtimeDatabaseNetworkService
                    .updateChildValues(with: [user: json], path: [RealtimeDatabaseKey.session, sessionId])
    }
    
    func cancelSession(of runningSetting: RunningSetting) -> Observable<Void> {
        guard let sessionId = runningSetting.sessionId else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: [RealtimeDatabaseKey.isCancelled: true],
            path: [RealtimeDatabaseKey.session, sessionId]
        )
    }
    
    func stopListen(sessionId: String, mate: String) {
        self.realtimeDatabaseNetworkService.stopListen(path: [RealtimeDatabaseKey.session, sessionId, mate])
    }
    
    func saveRunningStatus(of user: String, isRunning: Bool) -> Observable<Void> {
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: [RealtimeDatabaseKey.isRunning: isRunning],
            path: [RealtimeDatabaseKey.state, user]
        )
    }
    
    func fetchRunningStatus(of mate: String) -> Observable<Bool> {
        return self.realtimeDatabaseNetworkService.fetch(of: [RealtimeDatabaseKey.state, mate])
            .map { data in
                guard let isRunning = data[RealtimeDatabaseKey.isRunning] as? Bool else {
                    return false
                }
                return isRunning
            }
    }
}
