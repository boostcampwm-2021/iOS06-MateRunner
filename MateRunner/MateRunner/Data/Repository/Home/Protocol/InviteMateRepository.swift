//
//  InviteMateRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxSwift

protocol InviteMateRepository {
    func createSession(invitation: Invitation, mate: String) -> Observable<Bool>
    func listenSession(invitation: Invitation) -> Observable<(Bool, Bool)>
    func fetchFCMToken(of mate: String) -> Observable<String>
    func sendInvitation(_ invitation: Invitation, fcmToken: String) -> Observable<Bool>
    func stopListen(invitation: Invitation)
}
