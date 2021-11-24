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

typealias FirebaseDictionary = [String: Any]

final class DefaultRealtimeDatabaseNetworkService: RealtimeDatabaseNetworkService {
    private let databaseReference: DatabaseReference = Database.database().reference()
    
    private func childReference(of path: [String]) -> DatabaseReference {
        var childReference = self.databaseReference
        for path in path {
            childReference = childReference.child(path)
        }
        
        return childReference
    }
    
    func updateChildValues(with value: [String: Any], path: [String]) -> Observable<Void> {
        let childReference = self.childReference(of: path)
        
        return PublishSubject<Void>.create { observer in
            childReference.updateChildValues(value, withCompletionBlock: { error, _ in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
            })

            return Disposables.create()
        }
    }
    
    func update(with value: Any, path: [String]) -> Observable<Void> {
        let childReference = self.childReference(of: path)
        
        return Observable<Void>.create { observer in
            childReference.setValue(value) { error, _ in
                if let error = error {
                    observer.onError(error)
                    observer.onCompleted()
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func listen(path: [String]) -> Observable<FirebaseDictionary> {
        let childReference = self.childReference(of: path)

        return BehaviorRelay<FirebaseDictionary>.create { observer in
            childReference.observe(DataEventType.value, with: { snapshot in
                guard let data = snapshot.value as? [String: Any] else {
                    observer.onError(FirebaseServiceError.nilDataError)
                    return
                }
                observer.onNext(data)
            })
            return Disposables.create()
        }
    }
    
    func stopListen(path: [String]) {
        let childReference = self.childReference(of: path)
        
        childReference.removeAllObservers()
    }
    
    func fetch(of path: [String])-> Observable<FirebaseDictionary> {
        let childReference = self.childReference(of: path)
        
        return Observable.create { observer in
            childReference.observeSingleEvent(of: .value, with: { snapshot in
                guard let data = snapshot.value as? [String: Any] else {
                    observer.onError(FirebaseServiceError.nilDataError)
                    observer.onCompleted()
                    return
                }
                observer.onNext(data)
                observer.onCompleted()
            }, withCancel: { _ in
                observer.onError(MockError.unknown)
                observer.onCompleted()
                return
            })
            return Disposables.create()
        }
    }
    
    func fetchNotificationState(of mate: String) -> Observable<Bool> {
        return self.fetch(of: ["notification/\(mate)"])
            .map { data in
                guard let isRunning = data["isOn"] as? Bool else {
                    return false
                }
                return isRunning
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
