//
//  Coordinating.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import Foundation

protocol Coordinating: AnyObject {
	var childCoordinators: [Coordinating] { get set }
	func start()
}
