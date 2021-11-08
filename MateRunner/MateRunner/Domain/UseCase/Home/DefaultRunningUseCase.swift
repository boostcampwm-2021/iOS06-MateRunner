//
//  DefaultRunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

final class DefaultRunningUseCase: RunningUseCase {
    private let coreMotionManager = CoreMotionManager()
	var runningTimeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	var cancelTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 3)
	var popUpTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 2)
	var inCancelled: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	var shouldShowPopUp: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var distance = BehaviorSubject(value: 0.0)
    var progress = BehaviorSubject(value: 0.0)
    var finishRunning = BehaviorSubject(value: false)
	private var runningTimeDisposeBag = DisposeBag()
	private var cancelTimeDisposeBag = DisposeBag()
	private var popUpTimeDisposeBag = DisposeBag()
	private let disposeBag = DisposeBag()

    func executePedometer() {
        self.coreMotionManager.startPedometer()
            .subscribe(onNext: { [weak self] distance in
                guard let newDistance = try? self?.distance.value() ?? 0.0 + distance else { return }
                self?.checkDistance(value: newDistance)
                self?.updateProgress(value: newDistance)
                self?.distance.onNext(self?.convertToKilometer(value: newDistance) ?? 0.0)
            })
            .disposed(by: self.disposeBag)
    }
	
	func executeTimer() {
		self.generateTimer()
			.bind(to: self.runningTimeSpent)
			.disposed(by: self.runningTimeDisposeBag)
	}
	
	func executeCancelTimer() {
		self.generateTimer()
			.subscribe(onNext: { [weak self] newTime in
				self?.shouldShowPopUp.onNext(true)
				self?.checkTimeOver(from: newTime, with: 3, emitTarget: self?.cancelTimeLeft) {
					self?.inCancelled.onNext(true)
					self?.cancelTimeDisposeBag = DisposeBag()
				}
			})
			.disposed(by: self.cancelTimeDisposeBag)
	}
	
	func executePopUpTimer() {
		self.generateTimer()
			.subscribe(onNext: { [weak self] newTime in
				self?.shouldShowPopUp.onNext(true)
				self?.checkTimeOver(from: newTime, with: 2, emitTarget: self?.popUpTimeLeft) {
					self?.shouldShowPopUp.onNext(false)
					self?.popUpTimeDisposeBag = DisposeBag()
				}
			})
			.disposed(by: self.popUpTimeDisposeBag)
	}
	
	func invalidateCancelTimer() {
		self.cancelTimeDisposeBag = DisposeBag()
		self.shouldShowPopUp.onNext(false)
		self.cancelTimeLeft.onNext(3)
	}
}

// MARK: - Private Functions

private extension DefaultRunningUseCase {
    func convertToKilometer(value: Double) -> Double {
        return round(value / 10) / 100
    }
    
    func checkDistance(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        if self.convertToKilometer(value: value) > 0.05 {
            self.finishRunning.onNext(true)
            self.coreMotionManager.stopPedometer()
        }
    }
    
    func updateProgress(value: Double) {
        // *Fix : 0.05 고정 값 데이터 받으면 변경해야함
        self.progress.onNext(self.convertToKilometer(value: value) / 0.05)
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
	
	func generateTimer() -> Observable<Int> {
		return Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: MainScheduler.instance
			)
			.map { $0 + 1 }
	}
}
