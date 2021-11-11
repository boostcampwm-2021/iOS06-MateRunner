//
//  DefaultMockInviteMateUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

struct FCMNotificationInfo: Codable {
    var title: String = "함께 달리기 초대"
    var body: String = "메이트의 초대가 도착했습니다!"
}

struct InvitationRequestDTO: Codable {
    let notification: FCMNotificationInfo
    let data: Invitation
    let to: String
    var priority: String = "high"
    var contentAvailable: Bool = true
    var mutableContent: Bool = true
}

struct Invitation: Codable {
    let sessionId: String
    let host: String
    let inviteTime: Int
    let mode: RunningMode
    let targetDistance: Int
    
    init(runningSetting: RunningSetting, host: String) {
        self.mode = runningSetting.mode ?? .team
        self.targetDistance = Int(runningSetting.targetDistance ?? 0)
        self.inviteTime = Int(runningSetting.dateTime?.timeIntervalSince1970 ?? 0)
        self.host = host
        self.sessionId = "session-\(host)-\(runningSetting.dateTime?.fullDateTimeNumberString() ?? "0")"
    }
    
    init(sessionId: String, host: String, inviteTime: Int, mode: RunningMode, targetDistance: Int) {
        self.sessionId = sessionId
        self.host = host
        self.inviteTime = inviteTime
        self.mode = mode
        self.targetDistance = targetDistance
    }
}

final class DefaultMockInviteMateUseCase {
    var repository = DefaultInviteMateRepository()
    var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
    var disposeBag: DisposeBag = DisposeBag()
    var isAccepted: PublishRelay<(Bool, Bool)> = PublishRelay<(Bool, Bool)>()
    var invitation: Invitation = Invitation(runningSetting: RunningSetting(
        mode: .team,
        targetDistance: 5,
        mateNickname: "jk",
        dateTime: Date()
    ), host: "honux")
    
    func inviteMate(_ mate: String) {
        self.repository.createSession(invitation: self.invitation, mate: mate)
            .debug()
            .subscribe { success in
                if success {
                    self.repository.listenSession(invitation: self.invitation)
                        .bind(to: self.isAccepted)
                        .disposed(by: self.disposeBag)
                }
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: self.disposeBag)
        
        self.repository.fetchFCMToken(of: mate)
            .debug()
            .subscribe(onNext: { token in
                self.repository.sendInvitation(
                    self.invitation,
                    fcmToken: token
                ).debug().bind(to: self.requestSuccess)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        self.isAccepted.subscribe { (isRecieved, isAccepted) in
            print(isRecieved, isAccepted)
            // isRecieved == true & isAccepted == true : 카운트다운 시작
            
            // isRecieved == true & isAccepted == false : 거절 안내
            
            // 1분 경과 & isRecieved == false & isAccepted == false : 시간 초과 안내
        }.disposed(by: disposeBag)
    }
}
