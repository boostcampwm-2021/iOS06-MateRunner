//
//  DefaultSingleRunningUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

class DefaultSingleRunningUseCase: SingleRunningUseCase {
	var timeSpent: BehaviorSubject<Int> = BehaviorSubject(value: 0)
	let disposeBag = DisposeBag()
	
	func executeTimer() {
		Observable<Int>
			.interval(
				RxTimeInterval.seconds(1),
				scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)
			)
			.map { $0 + 1 }
			.bind(to: self.timeSpent)
			.disposed(by: disposeBag)
			
	}
}
