//
//  RunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxCocoa
import RxSwift

final class RunningResultViewModel {
    let runningResultUseCase: RunningResultUseCase = RunningResultUseCase()
    
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        @BehaviorRelayProperty var dateTime: String?
        @BehaviorRelayProperty var korDateTime: String?
        @BehaviorRelayProperty var mode: String?
        @BehaviorRelayProperty var distance: String?
        @BehaviorRelayProperty var kcal: String?
        @BehaviorRelayProperty var time: String?
        @BehaviorRelayProperty var points: [CLLocationCoordinate2D] = []
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let runningResult = input.load
            .map { self.runningResultUseCase.getRunningResult() }
        
        runningResult.map { $0.dateTime }
        .map { "\($0)" }
        .drive(output.$dateTime)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.dateTime }
        .map { "\($0)" }
        .drive(output.$korDateTime)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.dateTime }
        .map { "혼자 달리기" }
        .drive(output.$mode)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.userDistance }
        .map { "\($0)" }
        .drive(output.$distance)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.kcal }
        .map { "\($0)" }
        .drive(output.$kcal)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.userTime }
        .map { "\($0)" }
        .drive(output.$time)
        .disposed(by: disposeBag)
        
        runningResult.map { $0.points }
        .drive(output.$points)
        .disposed(by: disposeBag)
        
        return output
    }
}
