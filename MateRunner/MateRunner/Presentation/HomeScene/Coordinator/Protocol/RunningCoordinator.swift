//
//  RunningCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import Foundation

protocol RunningCoordinator: Coordinator {
    func pushRunningViewController(with settingData: RunningSetting?)
    func pushRunningResultViewController(with runningResult: RunningResult)
}
