//
//  RunningPreparationViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class RunningPreparationViewModel {
	struct Input { let viewDidLoadEvent: Observable<Void> }
	struct Output {
		@BehaviorRelayProperty var timeLeft: String?
		@BehaviorRelayProperty var navigateToNext: Void?
	}

	let useCase: RunningPreparationUseCase
	private let maxPreparationTime = 3
	
	init(useCase: RunningPreparationUseCase) {
		self.useCase = useCase
	}
	
	func transform(from input: Input, disposeBag: DisposeBag) -> Output {
		let output = Output()
		input.viewDidLoadEvent
			.subscribe(onNext: { self.useCase.execute() })
			.disposed(by: disposeBag)
		
		self.useCase.timeSpent
			.map({ "\(self.maxPreparationTime - $0)" })
			.bind(to: output.$timeLeft)
			.disposed(by: disposeBag)
		
		self.useCase.timeSpent
			.filter({ $0 == self.maxPreparationTime })
			.map({ _ in })
			.bind(to: output.$navigateToNext)
			.disposed(by: disposeBag)
		
		return output
	}
}
