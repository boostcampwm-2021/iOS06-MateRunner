//
//  RunningPreparationUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/04.
//

import Foundation

import RxSwift

protocol RunningPreparationUseCase {
	var timeSpent: BehaviorSubject<Int> { get set }
	func execute()
}
