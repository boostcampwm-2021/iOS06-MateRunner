//
//  InvitationWaitingUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/11.
//

import Foundation

import RxRelay
import RxSwift

protocol InvitationWaitingUseCase {
    var runningSetting: RunningSetting { get set }
    var requestSuccess: PublishRelay<Bool> { get set }
    var requestStatus: PublishSubject<(Bool, Bool)> { get set }
    var isAccepted: PublishSubject<Bool> { get set }
    var isRejected: PublishSubject<Bool> { get set }
    var isCanceled: PublishSubject<Bool> { get set }
    func inviteMate()
}
