//
//  RunningSettingUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/04.
//

import Foundation

import RxSwift

protocol RunningSettingUseCase {
    var runningSetting: BehaviorSubject<RunningSetting> { get set }
    var mateIsRunning: PublishSubject<Bool> { get set }
    func updateHostNickname()
    func updateSessionId()
    func updateMode(mode: RunningMode)
    func updateTargetDistance(distance: Double)
    func deleteMateNickname()
    func updateMateNickname(nickname: String)
    func updateDateTime(date: Date)
 }
