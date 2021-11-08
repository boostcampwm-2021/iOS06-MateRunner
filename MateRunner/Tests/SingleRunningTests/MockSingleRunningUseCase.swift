//
//  MockSingleRunningUseCase.swift
//  SingleRunningTests
//
//  Created by 전여훈 on 2021/11/06.
//

import Foundation

import RxSwift

class MockSingleRunningUseCase: SingleRunningUseCase {
	var timeSpent = BehaviorSubject<Int>(value: 0)
	var callCount = 0
	let mockDataList = [0, 1, 10, 30, 60, 90, 600, 3600, 4210]
	
	func executeTimer() {
		callCount += 1
		self.timeSpent.onNext(self.mockDataList[callCount])
	}
}
