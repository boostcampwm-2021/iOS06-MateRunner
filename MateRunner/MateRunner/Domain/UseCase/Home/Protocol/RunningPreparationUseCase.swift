//
//  RunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/04.
//

import Foundation

import RxSwift

protocol RunningPreparationUseCase {
	var timeLeft: BehaviorSubject<Int> { get set }
	var isTimeOver: BehaviorSubject<Bool> { get set }
	func executeTimer()
}
