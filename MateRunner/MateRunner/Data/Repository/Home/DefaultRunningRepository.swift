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
        return self.realtimeDatabaseNetworkService.listen(path: ["session", "\(sessionId)/\(mate)"])
            .map { data in
                guard let distance = data["elapsedDistance"] as? Double,
                      let time = data["elapsedTime"] as? Int else {
                          return RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
                      }
                return RunningRealTimeData(elapsedDistance: distance, elapsedTime: time)
            }
    }
    
    func listenIsCancelled(of sessionId: String) -> Observable<Bool> {
        return self.realtimeDatabaseNetworkService.listen(path: ["session", sessionId])
            .map { data in
                guard let isCancelled = data["isCancelled"] as? Bool else {
                    return false
                }
                return isCancelled
            }
    }
    
    func save(_ domain: RunningRealTimeData, sessionId: String, user: String) -> Observable<Void> {
        guard let data = try? JSONEncoder.init().encode(domain),
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.realtimeDatabaseNetworkService
                    .updateChildValues(with: [user: json], path: ["session", "\(sessionId)"])
    }
    
    func cancelSession(of runningSetting: RunningSetting) -> Observable<Void> {
        guard let sessionId = runningSetting.sessionId else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: ["isCancelled": true],
            path: ["session", "\(sessionId)"]
        )
    }
    
    func stopListen(sessionId: String, mate: String) {
        self.realtimeDatabaseNetworkService.stopListen(path: ["session", "\(sessionId)/\(mate)"])
    }
}
