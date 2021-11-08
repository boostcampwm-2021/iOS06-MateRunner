//
//  RunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class DefaultRunningPreparationUseCase: RunningPreparationUseCase {
	var timeLeft = BehaviorSubject(value: 3)
	var isTimeOver = BehaviorSubject(value: false)
	private let maxTime = 3
	
	func executeTimer() {
		var time = 0
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
			time += 1
			if time == self?.maxTime {
				timer.invalidate()
				self?.isTimeOver.onNext(true)
			}
			self?.timeLeft.onNext((self?.maxTime ?? 3) - time)
		}
	}
	private func checkTimeOver(timeLeft: Int) -> Bool {
		return timeLeft >= self.maxTime
	}
}
