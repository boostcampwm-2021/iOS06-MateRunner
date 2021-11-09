//
//  TeamRunningViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import RxRelay
import RxSwift

final class TeamRunningViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    struct Output {
        @BehaviorRelayProperty var myDistance: Double = 0
        @BehaviorRelayProperty var mateDistance: Double = 0
        @BehaviorRelayProperty var totalDistance: Double = 0
    }

    let teamRunningUseCase = DefaultTeamRunningUseCase()
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.teamRunningUseCase.execute()
            })
            .disposed(by: disposeBag)
        
        self.teamRunningUseCase.mateRunningData
            .catchAndReturn(RunningRealTimeData(elapsedDistance: 0, elapsedTime: 0))
            .map { $0.elapsedDistance }
            .bind(to: output.$mateDistance)
            .disposed(by: disposeBag)
        
        self.teamRunningUseCase.totalDistance
            .bind(to: output.$totalDistance)
            .disposed(by: disposeBag)
        
        self.teamRunningUseCase.myDistance
            .bind(to: output.$myDistance)
            .disposed(by: disposeBag)
        
        return output
    }
}
