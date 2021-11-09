//
//  AppCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

class AppCoordinator: Coordinating {
	var childCoordinators: [Coordinating] = []
	let window: UIWindow?
	
	init(_ window: UIWindow?) {
		self.window = window
		window?.makeKeyAndVisible()
	}
	
	func start() {
		let tabBarController = TabBarController()
		self.window?.rootViewController = tabBarController
	}
}
