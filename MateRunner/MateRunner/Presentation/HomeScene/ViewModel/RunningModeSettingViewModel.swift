//
//  RunningModeSettingViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/02.
//

import Foundation

import RxSwift
import RxCocoa

final class RunningModeSettingViewModel {
    struct Input {
        let singleButtonTapEvent: Driver<Void>
        let mateButtonTapEvent: Driver<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var runningMode: RunningMode?
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        input.singleButtonTapEvent
            .do(onNext: {
                output.runningMode = RunningMode.single
            })
            .drive()
            .disposed(by: disposeBag)

        input.mateButtonTapEvent
            .do(onNext: {
                output.runningMode = RunningMode.mate(.race)
            })
            .drive()
            .disposed(by: disposeBag)

        return output
    }
}
