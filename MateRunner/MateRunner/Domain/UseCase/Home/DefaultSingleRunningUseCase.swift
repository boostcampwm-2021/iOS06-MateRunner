//
//  DefaultSingleRunningUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

final class DefaultSingleRunningUseCase: SingleRunningUseCase {
	var runningTimeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	var cancelTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 3)
	var popUpTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 2)
	var navigateToNext: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	var isPopUpNeeded: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	private var runningTimeDisposeBag = DisposeBag()
	private var cancelTimeDisposeBag = DisposeBag()
	private var popUpTimeDisposeBag = DisposeBag()
	
	func executeTimer() {
		self.generateTimer()
			.bind(to: self.runningTimeSpent)
			.disposed(by: self.runningTimeDisposeBag)
	}
	
	func executeCancelTimer() {
		self.generateTimer()
			.subscribe(onNext: { [weak self] newTime in
				self?.isPopUpNeeded.onNext(true)
				self?.checkTimeOver(from: newTime, with: 3, emitTarget: self?.cancelTimeLeft) {
					self?.navigateToNext.onNext(true)
					self?.cancelTimeDisposeBag = DisposeBag()
				}
			})
			.disposed(by: self.cancelTimeDisposeBag)
	}
	
	func executePopUpTimer() {
		self.generateTimer()
			.subscribe(onNext: { [weak self] newTime in
				self?.isPopUpNeeded.onNext(true)
				self?.checkTimeOver(from: newTime, with: 2, emitTarget: self?.popUpTimeLeft) {
					self?.isPopUpNeeded.onNext(false)
					self?.popUpTimeDisposeBag = DisposeBag()
				}
			})
			.disposed(by: self.popUpTimeDisposeBag)
	}
	
	func invalidateCancelTimer() {
		self.cancelTimeDisposeBag = DisposeBag()
		self.isPopUpNeeded.onNext(false)
		self.cancelTimeLeft.onNext(3)
	}
	
	func checkTimeOver(
		from time: Int,
		with limitTime: Int,
		emitTarget: BehaviorSubject<Int>?,
		actionAtLimit: () -> Void
	) {
		guard let emitTarget = emitTarget else { return }
		emitTarget.onNext(limitTime - time)
		if time >= limitTime {
			actionAtLimit()
		}
	}
	
	private func generateTimer() -> Observable<Int> {
		return Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: MainScheduler.instance
			)
			.map { $0 + 1 }
	}
}
