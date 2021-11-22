//
//  InviteMateRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

protocol InviteMateRepository {
    func createSession(invitation: Invitation, mate: String) -> Observable<Void>
    func listenInvitationResponse(of invitation: Invitation) -> Observable<(Bool, Bool)>
    func fetchFCMToken(of mate: String) -> Observable<String>
    func sendInvitation(_ invitation: Invitation, fcmToken: String) -> Observable<Void>
    func stopListen(invitation: Invitation)
}
