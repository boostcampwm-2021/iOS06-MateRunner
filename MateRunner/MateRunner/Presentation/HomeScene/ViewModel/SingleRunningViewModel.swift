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
		let finishButtonLongPressDidBeginEvent: Observable<Void>
		let finishButtonLongPressDidEndEvent: Observable<Void>
	}
	struct Output {
		@BehaviorRelayProperty var timeSpent: String = ""
		@BehaviorRelayProperty var cancelTime: String = ""
		@BehaviorRelayProperty var isToasterNeeded: Bool = false
		@BehaviorRelayProperty var navigateToResult: Bool = false
	}
	
	func transform(from input: Input, disposeBag: DisposeBag) -> Output {
		let output = Output()
		input.viewDidLoadEvent
			.subscribe(onNext: { [weak self] in
				self?.singleRunningUseCase.executeTimer()
			})
			.disposed(by: disposeBag)
		
		input.finishButtonLongPressDidBeginEvent
			.debug()
			.subscribe(onNext: { [weak self] in
				self?.singleRunningUseCase.executeCancelTimer()
			})
			.disposed(by: disposeBag)
	
		input.finishButtonLongPressDidEndEvent
			.debug()
			.subscribe(onNext: { [weak self] in
				self?.singleRunningUseCase.invalidateCancelTimer()
			})
			.disposed(by: disposeBag)
		
		self.singleRunningUseCase.cancelTimeLeft
			.map({ $0 == 3 ? "종료" : "\($0)" })
			.bind(to: output.$cancelTime)
			.disposed(by: disposeBag)
		
		self.singleRunningUseCase.navigateToNext
			.bind(to: output.$navigateToResult)
			.disposed(by: disposeBag)
		
		self.singleRunningUseCase.runningTimeSpent
			.map(convertToTimeFormat)
			.bind(to: output.$timeSpent)
			.disposed(by: disposeBag)
			
		return output
	}
	
	private func convertToTimeFormat(from seconds: Int) -> String {
		func padZeros(to text: String) -> String {
			if text.count < 2 { return "0" + text }
			return text
		}
		let hrs = padZeros(to: String(seconds / 3600))
		let mins = padZeros(to: String(seconds % 3600 / 60))
		let sec = padZeros(to: String(seconds % 3600 % 60))
		
		return "\(hrs):\(mins):\(sec)"
	}
}
