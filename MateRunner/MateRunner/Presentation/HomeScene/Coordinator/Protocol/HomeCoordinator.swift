//
//  HomeCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func createHomeViewController() -> UIViewController
    func pushRunningModeSettingViewController()
    func pushMateRunningModeSettingViewController()
    func pushDistanceSettingViewController()
    func pushRunningPreparationViewController()
}
