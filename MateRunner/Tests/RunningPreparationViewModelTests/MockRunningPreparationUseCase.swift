//
//  MockRunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class MockRunningPreparationUseCase: RunningPreparationUseCase {
	var timeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	private(set) var expectedOutput: Int = 0
	
	func execute() {
		timeSpent.onNext(1)
		timeSpent.onNext(2)
		timeSpent.onNext(3)
	}
}
