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
	var cancelTimeLeft: BehaviorSubject<Int> { get set }
	var inCancelled: BehaviorSubject<Bool> { get set }
	var popUpTimeLeft: BehaviorSubject<Int> { get set }
	var shouldShowPopUp: BehaviorSubject<Bool> { get set }
	func executeTimer()
	func executeCancelTimer()
	func invalidateCancelTimer()
	func executePopUpTimer()
}
