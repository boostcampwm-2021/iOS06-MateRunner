//
//  InvitationRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//
import Foundation

import RxSwift

protocol InvitationRepository {
    func fetchCancellationStatus(of invitation: Invitation) -> Observable<Bool>
    func saveInvitationResponse(accept: Bool, invitation: Invitation) -> Observable<Void>
}
