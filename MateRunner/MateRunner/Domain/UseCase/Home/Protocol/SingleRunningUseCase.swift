//
//  SingleRunningUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

protocol SingleRunningUseCase {
	var runningTimeSpent: BehaviorSubject<Int> { get set }
	var cancelTimeLeft: PublishSubject<Int> { get set }
	var navigateToNext: BehaviorSubject<Bool> { get set }
	var popUpTimeLeft: PublishSubject<Int> { get set }
	func executeTimer()
	func executeCancelTimer()
	func invalidateCancelTimer()
	func executePopUpTimer()
}
