//
//  RunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class DefaultRunningPreparationUseCase: RunningPreparationUseCase {
	var timeSpent = BehaviorSubject(value: 0)
	private let maxTime = 3
	
	func execute() {
		var time = 0
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
			time += 1
			if time == self?.maxTime { timer.invalidate() }
			self?.timeSpent.onNext(time)
		}
	}
}
