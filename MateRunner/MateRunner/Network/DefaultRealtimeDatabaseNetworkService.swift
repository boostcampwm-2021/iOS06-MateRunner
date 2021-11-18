//
//  DefaultRealtimeDatabaseNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/17.
//

import Foundation

import Firebase
import RxRelay
import RxSwift

final class DefaultRealtimeDatabaseNetworkService: RealtimeDatabaseNetworkService {
    private let databaseReference: DatabaseReference = Database.database().reference()
    
    func update(value: [String: Any], path: [String]) -> Observable<Bool> {
        var childReference = self.databaseReference
        for path in path {
            childReference = childReference.child(path)
        }
        
        return Observable<Bool>.create { observer in
            childReference.updateChildValues(value, withCompletionBlock: { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(true)
            })

            return Disposables.create()
        }
    }
    
    func fetchFCMToken(of mate: String)-> Observable<String> {
        return BehaviorRelay.create { [weak self] observer in
            self?.databaseReference.child("fcmToken/\(mate)").observeSingleEvent(of: .value, with: { snapshot in
                guard let fcmToken = snapshot.value as? String else {
                    observer.onError(MockError.unknown)
                    return
                }
                observer.onNext(fcmToken)
            }, withCancel: { _ in
                observer.onError(MockError.unknown)
                return
            })
            return Disposables.create()
        }
    }
}
