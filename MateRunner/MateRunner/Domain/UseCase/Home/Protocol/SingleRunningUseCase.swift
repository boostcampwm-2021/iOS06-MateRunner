//
//  SingleRunningUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

protocol SingleRunningUseCase {
	var timeSpent: BehaviorSubject<Int> { get set }
	func executeTimer()
}
