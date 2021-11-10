//
//  SettingCoordinatorDidFinishDelegate.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/10.
//

import Foundation

protocol SettingCoordinatorDidFinishDelegate: AnyObject {
    func settingCoordinatorDidFinish(with runningSettingData: RunningSetting)
}
