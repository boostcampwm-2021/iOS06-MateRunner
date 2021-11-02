//
//  RunningModeViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/02.
//

import Foundation
import RxSwift

enum RunningMode {
    case race
    case team
}

final class RunningModeViewModel {
    var mode = BehaviorSubject(value: RunningMode.race)
    
    func changeMode(to mode: RunningMode) {
        self.mode.onNext(mode)
    }
}
