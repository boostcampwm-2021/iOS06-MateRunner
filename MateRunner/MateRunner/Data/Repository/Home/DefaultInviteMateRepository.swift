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

final class DefaultInviteMateRepository: InviteMateRepository {
    private let realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService
    private let urlSessionNetworkService: URLSessionNetworkService
    var ref: DatabaseReference = Database.database().reference()
    
    init(realtimeDatabaseNetworkService: RealtimeDatabaseNetworkService,
         urlSessionNetworkService: URLSessionNetworkService
    ) {
        self.realtimeDatabaseNetworkService = realtimeDatabaseNetworkService
        self.urlSessionNetworkService = urlSessionNetworkService
    }
    
    func createSession(invitation: Invitation, mate: String) -> Observable<Void> {
        let runningRealTimeData = RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0)
        
        guard let data = try? JSONEncoder.init().encode(runningRealTimeData),
              let runningRealTimeJsonData = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
              ) else {
                  return Observable.error(FirebaseServiceError.nilDataError)
              }
        
        let sessionId = invitation.sessionId
        let dateTime = invitation.inviteTime
        let host = invitation.host
        let mode = invitation.mode
        let targetDistance = invitation.targetDistance
        
        return self.realtimeDatabaseNetworkService.update(
            with: [
                "dateTime": dateTime,
                host: runningRealTimeJsonData,
                mate: runningRealTimeJsonData,
                "isAccepted": false,
                "isReceived": false,
                "isCancelled": false,
                "mode": mode.rawValue,
                "targetDistance": targetDistance
            ],
            path: ["session", sessionId]
        )
    }
    
    func cancelSession(invitation: Invitation) -> Observable<Void> {
        let sessionId = invitation.sessionId
        
        return self.realtimeDatabaseNetworkService.updateChildValues(
            with: ["isCancelled": true],
            path: ["session", "\(sessionId)"]
        )
    }
    
    func listenInvitationResponse(of invitation: Invitation) -> Observable<(Bool, Bool)> {
        let sessionId = invitation.sessionId
        
        return Observable<(Bool, Bool)>.create { [weak self] observer in
            self?.ref.child("session").child("\(sessionId)").observe(DataEventType.value, with: { snapshot in

                guard let isRecieved = snapshot.childSnapshot(forPath: "isReceived").value as? Bool,
                      let isAccepted = snapshot.childSnapshot(forPath: "isAccepted").value as? Bool else {
                          observer.onError(MockError.unknown)
                          observer.onCompleted()
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
        return self.realtimeDatabaseNetworkService.fetchFCMToken(of: mate)
    }
    
    func sendInvitation(_ invitation: Invitation, fcmToken: String) -> Observable<Void> {
        let dto = MessagingRequestDTO(
            title: "함께 달리기 초대",
            body: "메이트 \(invitation.host)님의 초대장이 도착했습니다!",
            data: invitation,
            to: fcmToken
        )
        
        return self.urlSessionNetworkService.post(
            dto,
            url: "https://fcm.googleapis.com/fcm/send",
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": Configuration.fcmServerKey
            ]
        )
            .map({ _ in })
    }
    
    func stopListen(invitation: Invitation) {
        let sessionId = invitation.sessionId
        self.realtimeDatabaseNetworkService.stopListen(path: ["session", "\(sessionId)"])
    }
}
