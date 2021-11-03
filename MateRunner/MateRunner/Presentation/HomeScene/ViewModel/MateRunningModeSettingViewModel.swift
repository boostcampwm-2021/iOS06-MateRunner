//
//  RunningModeViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/02.
//

import Foundation

import RxCocoa
import RxSwift

final class MateRunningModeSettingViewModel {
    struct Input {
        let raceModeButtonTapEvent: Driver<UIGestureRecognizer>
        let teamModeButtonTapEvent: Driver<UIGestureRecognizer>
    }
    
    struct Output {
        @BehaviorRelayProperty var mode: MateRunningMode = .race
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        input.raceModeButtonTapEvent
            .drive(onNext: { _ in
                output.mode = .race
            }).disposed(by: disposeBag)
        
        input.teamModeButtonTapEvent
            .drive(onNext: { _ in
                output.mode = .team
            }).disposed(by: disposeBag)
        
        return output
    }
}
