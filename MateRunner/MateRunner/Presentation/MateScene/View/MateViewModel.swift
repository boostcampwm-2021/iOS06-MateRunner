//
//  MateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class MateViewModel {
    var mate: [String: String] = [:] // usecase에서 fetch 받고 순서맞춘 딕셔너리
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var mate: [String: String]?
    }
    
    let mateUseCase: MateUseCase
    
    init(mateUseCase: MateUseCase) {
        self.mateUseCase = mateUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.mateUseCase.fetchMateInfo()
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mate
            .subscribe(onNext: { [weak self] mate in
                self?.mate = mate
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
