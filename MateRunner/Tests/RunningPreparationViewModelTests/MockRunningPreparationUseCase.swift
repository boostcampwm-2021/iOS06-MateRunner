//
//  MockRunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class MockRunningPreparationUseCase: RunningPreparationUseCase {
	var timeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	var isTimeOver: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	
	func executeTimer() {
		self.timeLeft.onNext(1)
		self.timeLeft.onNext(2)
		self.timeLeft.onNext(3)
		self.isTimeOver.onNext(true)
	}
}
