//
//  RunningModeViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/02.
//

import Foundation

import RxCocoa
import RxSwift

enum MateRunningMode {
    case race, team
    
    var title: String {
        switch self {
        case .race:
            return "경쟁 모드"
        case .team:
            return "협동 모드"
        }
    }
    
    var description: String {
        switch self {
        case .race:
            return "정해진 거리를 누가 더 빨리 달리는지 메이트와 대결해보세요!"
        case .team:
            return "정해진 거리를 메이트와 함께 달려서 달성해보세요!"
        }
    }
}

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
