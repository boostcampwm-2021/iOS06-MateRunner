//
//  SingleRunningViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

class SingleRunningViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    struct Output {
        @BehaviorRelayProperty var distance: Double?
        @BehaviorRelayProperty var calorie: Int?
    }

    let runningUseCase: DefaultRunningUseCase
    
    init(runningUseCase: DefaultRunningUseCase) {
        self.runningUseCase = runningUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.runningUseCase.executePedometer()
            })
            .disposed(by: disposeBag)
        
        self.runningUseCase.distance
            .bind(to: output.$distance)
            .disposed(by: disposeBag)
        
        return output
    }
}
