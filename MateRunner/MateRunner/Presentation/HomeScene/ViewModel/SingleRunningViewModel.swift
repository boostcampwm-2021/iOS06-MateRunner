//
//  SingleRunningViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

class SingleRunningViewModel {
	let singleRunningUseCase: SingleRunningUseCase
	
	init(singleRunningUseCase: SingleRunningUseCase) {
		self.singleRunningUseCase = singleRunningUseCase
	}
	
	struct Input {
		let viewDidLoadEvent: Observable<Void>
	}
	struct Output {
		@BehaviorRelayProperty var timeLeft: String?
	}
	
	func transform(from input: Input, disposeBag: DisposeBag) -> Output {
		let output = Output()
		input.viewDidLoadEvent
			.subscribe(onNext: { [weak self] in
				self?.singleRunningUseCase.executeTimer()
			})
			.disposed(by: disposeBag)
		
		self.singleRunningUseCase.timeSpent
			.map(convertToTimeFormat)
			.bind(to: output.$timeLeft)
			.disposed(by: disposeBag)
			
		return output
	}
	
	private func convertToTimeFormat(from seconds: Int) -> String {
		func padZeros(to text: String) -> String {
			if text.count < 2 { return "0" + text }
			return text
		}
		let hrs = padZeros(to: String(seconds / 3600))
		let mins = padZeros(to: String(seconds / 60))
		let sec = padZeros(to: String(seconds % 60))
		
		return "\(hrs):\(mins):\(sec)"
	}
}
