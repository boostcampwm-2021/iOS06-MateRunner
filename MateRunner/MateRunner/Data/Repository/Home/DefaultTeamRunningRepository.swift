//
//  DefaultTeamRunningRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import Firebase
import RxCocoa
import RxSwift

enum MockError: Error {
    case unknown
}

final class DefaultTeamRunningRepository: TeamRunningRepository {
    var ref: DatabaseReference = Database.database().reference()
    
    func listen(sessionId: String = "session00", mate: String = "honux") -> Observable<RunningRealTimeData> {
        return BehaviorRelay<RunningRealTimeData>.create { [weak self] observe in
            self?.ref.child("session").child("\(sessionId)/\(mate)").observe(DataEventType.value, with: { snapshot in
                
                guard let distance = snapshot.childSnapshot(forPath: "elapsedDistance").value as? Double,
                        let time = snapshot.childSnapshot(forPath: "elapsedTime").value as? Int else {
                        observe.onError(MockError.unknown)
                        return
                }
                let data = RunningRealTimeData(elapsedDistance: distance, elapsedTime: time)
                
                observe.onNext(data)
            })
            return Disposables.create()
        }
    }
    
    func save(_ domain: RunningRealTimeData, sessionId: String = "session00", user: String = "jk") {
        let encoder = JSONEncoder.init()
        guard let data = try? encoder.encode(domain),
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
        
        self.ref.child("session").child("\(sessionId)/\(user)").setValue(json) { error, _ in
            print(error)
        }
    }
    
    func stopListen(sessionId: String = "session00", mate: String = "honux") {
        self.ref.child("session").child("\(sessionId)/\(mate)").removeAllObservers()
    }
}
