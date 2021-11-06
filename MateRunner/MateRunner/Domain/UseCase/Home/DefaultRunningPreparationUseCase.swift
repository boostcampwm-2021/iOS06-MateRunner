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
	var timerDisposeBag = DisposeBag()
	private let maxTime = 3
	
	func executeTimer() {
		Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: MainScheduler.instance
			)
			.map { $0 + 1 }
			.subscribe(onNext: { [weak self] newTime in
				self?.updateTime(with: newTime)
			})
			.disposed(by: timerDisposeBag)
	}
	private func updateTime(with time: Int) {
		if time == self.maxTime {
			self.timerDisposeBag = DisposeBag()
			self.isTimeOver.onNext(true)
		}
		self.timeLeft.onNext((self.maxTime) - time)
	}
	
	private func checkTimeOver(timeLeft: Int) -> Bool {
		return timeLeft >= self.maxTime
	}
}
