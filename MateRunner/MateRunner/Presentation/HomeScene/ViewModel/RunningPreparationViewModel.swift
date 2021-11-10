//
//  RunningPreparationViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

import RxSwift

class RunningPreparationViewModel {
    private let runningPreparationUseCase: RunningPreparationUseCase
    private weak var coordinator: SettingCoordinator?
    private let maxPreparationTime = 3
    
	struct Input {
		let viewDidLoadEvent: Observable<Void>
	}
	struct Output {
		@BehaviorRelayProperty var timeLeft: String?
		@BehaviorRelayProperty var navigateToNext: Bool?
	}
	
    init(coordinator: SettingCoordinator, runningPreparationUseCase: RunningPreparationUseCase) {
        self.coordinator = coordinator
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
            .debug()
            .subscribe(onNext: { [weak self] isOver in
                isOver ? self?.coordinator?.finish() : Void()
            })
			.disposed(by: disposeBag)
		
		return output
	}
}
