//
//  RunningPreparationViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class RunningPreparationViewModel {
	struct Input {
		let viewDidLoadEvent: Observable<Void>
	}
	struct Output {
		@BehaviorRelayProperty var timeLeft: String?
		@BehaviorRelayProperty var navigateToNext: Bool?
	}

	let runningPreparationUseCase: RunningPreparationUseCase
	private let maxPreparationTime = 3
	
	init(runningPreparationUseCase: RunningPreparationUseCase) {
		self.runningPreparationUseCase = runningPreparationUseCase
	}
	
	func transform(from input: Input, disposeBag: DisposeBag) -> Output {
		let output = Output()
		input.viewDidLoadEvent
			.subscribe(onNext: { self.runningPreparationUseCase.executeTimer() })
			.disposed(by: disposeBag)
		
		self.runningPreparationUseCase.timeLeft
			.map({ "\($0)" })
			.bind(to: output.$timeLeft)
			.disposed(by: disposeBag)
		
		self.runningPreparationUseCase.isTimeOver
			.bind(to: output.$navigateToNext)
			.disposed(by: disposeBag)
		
		return output
	}
}
