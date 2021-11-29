//
//  MockSingleRunningUseCase.swift
//  SingleRunningTests
//
//  Created by 전여훈 on 2021/11/06.
//

import Foundation

import RxSwift

class MockSingleRunningUseCase: RunningUseCase {
	var runningTimeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	var cancelTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 3)
	var popUpTimeLeft: BehaviorSubject<Int> = BehaviorSubject(value: 2)
	var inCancelled: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	var shouldShowPopUp: BehaviorSubject<Bool> = BehaviorSubject(value: false)
	var distance = BehaviorSubject(value: 0.0)
	var progress = BehaviorSubject(value: 0.0)
	var finishRunning = BehaviorSubject(value: false)
	
	func executePedometer() {}
	func executeCancelTimer() {}
	func executePopUpTimer() {}
	func invalidateCancelTimer() {}
	
	var callCount = 0
	let mockDataList = [0, 1, 10, 30, 60, 90, 600, 3600, 4210]
	
	func executeTimer() {
		self.callCount += 1
		self.runningTimeSpent.onNext(self.mockDataList[callCount])
	}
}
