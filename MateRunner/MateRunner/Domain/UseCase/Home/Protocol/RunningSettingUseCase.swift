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
    func updateHost()
    func updateMode(mode: RunningMode)
    func updateTargetDistance(distance: Double)
    func updateMateNickname(nickname: String)
    func updateDateTime(date: Date)
 }
