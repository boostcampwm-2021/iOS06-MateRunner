//
//  SingleRunningViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift
import RxRelay

final class SingleRunningViewModel {
    struct Input {
		let viewDidLoadEvent: Observable<Void>
		let finishButtonLongPressDidBeginEvent: Observable<Void>
		let finishButtonLongPressDidCancelEvent: Observable<Void>
		let finishButtonDidTapEvent: Observable<Void>
    }
    struct Output {
        @BehaviorRelayProperty var distance: Double?
        @BehaviorRelayProperty var progress: Double?
        @BehaviorRelayProperty var calorie: Int?
        @BehaviorRelayProperty var finishRunning: Bool?
		@BehaviorRelayProperty var timeSpent: String = ""
		@BehaviorRelayProperty var navigateToResult: Bool = false
		var cancelTime: PublishRelay<String> = PublishRelay<String>()
		var isToasterNeeded: PublishRelay<Bool> = PublishRelay<Bool>()
    }

    let runningUseCase: RunningUseCase
    
    init(runningUseCase: RunningUseCase) {
        self.runningUseCase = runningUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningUseCase.executePedometer()
                self?.runningUseCase.executeActivity()
            })
            .disposed(by: disposeBag)
		input.viewDidLoadEvent
			.subscribe(onNext: { [weak self] in
				self?.runningUseCase.executeTimer()
			})
			.disposed(by: disposeBag)
		
		input.finishButtonLongPressDidBeginEvent
			.subscribe(onNext: { [weak self] in
				self?.runningUseCase.executeCancelTimer()
			})
			.disposed(by: disposeBag)
		
		input.finishButtonLongPressDidCancelEvent
			.subscribe(onNext: { [weak self] in
				self?.runningUseCase.invalidateCancelTimer()
			})
			.disposed(by: disposeBag)
		
		input.finishButtonDidTapEvent
			.subscribe(onNext: { [weak self] in
				self?.runningUseCase.executePopUpTimer()
			})
			.disposed(by: disposeBag)
		
		self.runningUseCase.cancelTimeLeft
			.map({ $0 == 3 ? "종료" : "\($0)" })
			.bind(to: output.cancelTime)
			.disposed(by: disposeBag)
		
		self.runningUseCase.inCancelled
			.bind(to: output.$navigateToResult)
			.disposed(by: disposeBag)
		
		self.runningUseCase.runningTimeSpent
			.map(self.convertToTimeFormat)
			.bind(to: output.$timeSpent)
			.disposed(by: disposeBag)
		
		self.runningUseCase.shouldShowPopUp
			.bind(to: output.isToasterNeeded)
			.disposed(by: disposeBag)
		
        self.runningUseCase.runningRealTimeData.myRunningRealTimeData.elapsedDistance
            .map { [weak self] distance in
                self?.convertToKilometer(value: distance)
            }
            .bind(to: output.$distance)
            .disposed(by: disposeBag)
        
        self.runningUseCase.progress
            .bind(to: output.$progress)
            .disposed(by: disposeBag)
        
        self.runningUseCase.runningRealTimeData.calorie
            .map { Int($0) }
            .bind(to: output.$calorie)
            .disposed(by: disposeBag)
        
        self.runningUseCase.finishRunning
            .bind(to: output.$finishRunning)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func convertToKilometer(value: Double) -> Double {
        return round(value / 10) / 100
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
