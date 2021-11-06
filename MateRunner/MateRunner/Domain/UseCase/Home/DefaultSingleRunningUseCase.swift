//
//  DefaultSingleRunningUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

class DefaultSingleRunningUseCase: SingleRunningUseCase {
	var runningTimeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	var cancelTimeLeft: PublishSubject<Int> = PublishSubject<Int>()
	var navigateToNext: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	var popUpTimeLeft: PublishSubject<Int> = PublishSubject<Int>()
	var runningTimeDisposeBag = DisposeBag()
	var cancelTimeDisposeBag = DisposeBag()
	var popUpTimeDisposeBag = DisposeBag()
	
	func executeTimer() {
		Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)
			)
			.map { $0 + 1 }
			.bind(to: self.runningTimeSpent)
			.disposed(by: self.runningTimeDisposeBag)
	}
	
	func executeCancelTimer() {
		Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)
			)
			.map { $0 + 1 }
			.subscribe(onNext: { [weak self] newTime in
				self?.checkTimeOver(newTime)
			})
			.disposed(by: self.cancelTimeDisposeBag)
	}
	
	func executePopUpTimer() {
		Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)
			)
			.map { $0 + 1 }
			.subscribe(onNext: { [weak self] newTime in
				self?.popUpTimeLeft.onNext(2 - newTime)
				if newTime == 3 {
					self?.popUpTimeDisposeBag = DisposeBag()
				}
			})
			.disposed(by: self.popUpTimeDisposeBag)
	}
	
	func invalidateCancelTimer() {
		self.cancelTimeDisposeBag = DisposeBag()
		self.cancelTimeLeft.onNext(3)
	}
	
	private func checkTimeOver(_ time: Int) {
		self.cancelTimeLeft.onNext(3 - time)
		if time == 3 {
			self.navigateToNext.onNext(true)
			self.cancelTimeDisposeBag = DisposeBag()
		}
	}
}
