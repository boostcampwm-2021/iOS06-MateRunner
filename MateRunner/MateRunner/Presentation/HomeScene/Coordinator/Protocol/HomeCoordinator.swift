//
//  HomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

protocol SettingCoordinator: Coordinator {
    func createHomeViewController() -> UIViewController
    func pushRunningModeSettingViewController()
    func pushMateRunningModeSettingViewController(with settingData: RunningSetting?)
    func pushDistanceSettingViewController(with settingData: RunningSetting?)
    func pushRunningPreparationViewController(with settingData: RunningSetting?)
}
