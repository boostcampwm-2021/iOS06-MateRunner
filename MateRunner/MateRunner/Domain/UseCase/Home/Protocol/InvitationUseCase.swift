//
//  InvitationUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//
import Foundation

import RxSwift

protocol InvitationUseCase {
    var invitation: Invitation { get set }
    func acceptInvitation() -> Observable<Bool>
    func rejectInvitation() -> Observable<Bool>
}
