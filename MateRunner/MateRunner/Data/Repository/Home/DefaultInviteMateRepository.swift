//
//  DefaultInviteMateRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import Foundation

import Firebase
import RxRelay
import RxSwift

final class DefaultInviteMateRepository {
    var ref: DatabaseReference = Database.database().reference()
    
    func createSession(invitation: Invitation, mate: String) -> Observable<Bool> {
        return BehaviorRelay<Bool>.create { [weak self] observe in
            let runningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
            
            guard let data = try? JSONEncoder.init().encode(runningRealTimeData),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                observe.onError(MockError.unknown)
                return Disposables.create()
            }
            
            let sessionId = invitation.sessionId
            let dateTime = invitation.inviteTime
            let host = invitation.host
            let mode = invitation.mode
            let targetDistance = invitation.targetDistance
            
            self?.ref.child("session").child("\(sessionId)").setValue([
                "dateTime": dateTime,
                host: json,
                mate: json,
                "isAccepted": false,
                "isReceived": false,
                "mode": mode.rawValue,
                "targetDistance": targetDistance
            ], withCompletionBlock: { error, _ in
                if error != nil {
                    observe.onError(MockError.unknown)
                    return
                }
                observe.onNext(true)
            })
            
            return Disposables.create()
        }

    }
    
    func listenSession(invitation: Invitation) -> Observable<(Bool, Bool)> {
        let sessionId = invitation.sessionId
        
        return Observable<(Bool, Bool)>.create { [weak self] observer in
            self?.ref.child("session").child("\(sessionId)").observe(DataEventType.value, with: { snapshot in
                guard let isRecieved = snapshot.childSnapshot(forPath: "isReceived").value as? Bool,
                      let isAccepted = snapshot.childSnapshot(forPath: "isAccepted").value as? Bool else {
                          observer.onError(MockError.unknown)
                          return
                      }
                
                if isRecieved || isAccepted {
                    observer.onNext((isRecieved, isAccepted))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }

    func fetchFCMToken(of mate: String)-> Observable<String> {
        return BehaviorRelay.create { [weak self] observer in
            self?.ref.child("fcmToken/\(mate)").observeSingleEvent(of: .value, with: { snapshot in
                guard let fcmToken = snapshot.value as? String else {
                    observer.onError(MockError.unknown)
                    return
                }
                observer.onNext(fcmToken)
            }, withCancel: { error in
                print(error.localizedDescription)
                observer.onError(MockError.unknown)
                return
            })
            return Disposables.create()
        }
    }
    
    func sendInvitation(_ invitation: Invitation, fcmToken: String) -> Observable<Bool> {
        return Observable.create { observer in
            let dto = InvitationRequestDTO(data: invitation, to: fcmToken)
            guard let url = URL(string: "https://fcm.googleapis.com/fcm/send"),
                  let json = try? JSONEncoder().encode(dto) else {
                observer.onNext(false)
                return Disposables.create()
            }
            let key0 = "key=AAAAIlcoX1A:APA91bEChOkNGbdKrk6IgSEpBbxJNLTR0zNrc6an2pLyOA6601ijI"
            let key1 = "oRsuqaYWIjVojqcGgevYtDAmT_LcFYUl89a_pi6fqtd3s0FJ9t27Dlmn0rKL-ILY-jknoyKpIQmeH6lEyXpGEcT"

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(key0+key1, forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { _, _, err in
                guard err == nil else {
                    print(err?.localizedDescription as Any)
                    observer.onError(MockError.unknown)
                    return
                }
                
                observer.onNext(true)
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func stopListen(invitation: Invitation) {
        print("stop listen")
        let sessionId = invitation.sessionId
        self.ref.child("session").child("\(sessionId)").removeAllObservers()
    }
}
