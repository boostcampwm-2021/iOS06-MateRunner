//
//  InvitationUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/15.
//
import Foundation

import RxRelay
import RxSwift

protocol InvitationUseCase {
    var invitation: Invitation { get set }
    var isCancelled: PublishSubject<Bool> { get set }
    func checkIsCancelled() -> Observable<Bool>
    func acceptInvitation() -> Observable<Void>
    func rejectInvitation() -> Observable<Void>
}
