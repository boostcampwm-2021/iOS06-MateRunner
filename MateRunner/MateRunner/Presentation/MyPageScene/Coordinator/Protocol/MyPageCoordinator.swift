//
//  MyPageCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

protocol MyPageCoordinator: Coordinator {
    func pushNotificationViewController()
    func pushProfileEditViewController(with nickname: String)
    func pushLicenseViewController()
    func popViewController()
}
