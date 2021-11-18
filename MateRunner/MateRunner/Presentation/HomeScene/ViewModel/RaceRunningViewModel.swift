//
//  RaceRunningViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import Foundation

import RxRelay
import RxSwift

final class RaceRunningViewModel {
    weak var coordinator: RunningCoordinator?
    private let runningUseCase: RunningUseCase
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let finishButtonLongPressDidBeginEvent: Observable<Void>
        let finishButtonLongPressDidCancelEvent: Observable<Void>
        let finishButtonDidTapEvent: Observable<Void>
    }
    struct Output {
        var myDistance = BehaviorRelay<String>(value: "0.00")
        var mateDistance = BehaviorRelay<String>(value: "0.00")
        var myProgress = BehaviorRelay<Double>(value: 0)
        var mateProgress = BehaviorRelay<Double>(value: 0)
        var calorie = PublishRelay<String>()
        var timeSpent = PublishRelay<String>()
        var cancelTimeLeft = PublishRelay<String>()
        var popUpShouldShow = PublishRelay<Bool>()
    }
    
    init(coordinator: RunningCoordinator, runningUseCase: RunningUseCase) {
        self.coordinator = coordinator
        self.runningUseCase = runningUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input, disposeBag: disposeBag)
        return createOutput(from: input, disposeBag: disposeBag)
    }
    
    private func configureInput(_ input: Input, disposeBag: DisposeBag) {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.runningUseCase.executePedometer()
                self?.runningUseCase.executeActivity()
                self?.runningUseCase.executeTimer()
                self?.runningUseCase.listenMateRunningRealTimeData()
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
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.runningUseCase.cancelTimeLeft
            .map({ $0 >= 3 ? "종료" : "\($0)" })
            .bind(to: output.cancelTimeLeft)
            .disposed(by: disposeBag)
        
        self.runningUseCase.runningData
            .map { data in
                Date.secondsToTimeString(from: data.myElapsedTime)
            }
            .bind(to: output.timeSpent)
            .disposed(by: disposeBag)
        
        self.runningUseCase.runningData
            .map { data in
                return String(data.myElapsedDistance
                                .convertToKilometer()
                                .doubleToString())
            }
            .bind(to: output.myDistance)
            .disposed(by: disposeBag)
        
        self.runningUseCase.runningData
            .map { data in
                return String(data.mateElapsedDistance
                                .convertToKilometer()
                                .doubleToString())
            }
            .bind(to: output.mateDistance)
            .disposed(by: disposeBag)
        
        self.runningUseCase.runningData
            .map { String(Int($0.calorie)) }
            .bind(to: output.calorie)
            .disposed(by: disposeBag)
        
        self.runningUseCase.shouldShowPopUp
            .bind(to: output.popUpShouldShow)
            .disposed(by: disposeBag)
        
        self.runningUseCase.myProgress
            .bind(to: output.myProgress)
            .disposed(by: disposeBag)
        
        self.runningUseCase.mateProgress
            .bind(to: output.mateProgress)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.runningUseCase.isFinished,
            self.runningUseCase.isCanceled,
            resultSelector: { ($0, $1) })
            .filter({ $0 || $1 })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_, isCanceled) in
                self?.coordinator?.pushRunningResultViewController(
                    with: self?.runningUseCase.createRunningResult(isCanceled: isCanceled)
                )
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
