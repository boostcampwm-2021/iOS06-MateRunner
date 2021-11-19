//
//  CoordinatorFinishDelegate.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
