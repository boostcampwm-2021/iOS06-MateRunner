//
//  HomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import Foundation

protocol HomeCoordinator: Coordinator, InvitationRecievable {
    func showSettingFlow()
    func showRunningFlow(with initialSettingData: RunningSetting)
}
