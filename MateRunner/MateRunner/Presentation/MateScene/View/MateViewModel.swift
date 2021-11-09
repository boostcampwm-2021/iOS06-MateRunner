//
//  MateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class MateViewModel {
    let mate: [String: String] = [:]
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        // usecase에서 fetch 받고 순서맞춘 딕셔너리가 와야할 것 같음
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
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension MateViewModel {
    func converToDictionary(from mate: BehaviorSubject<[String: String]>) -> [String: String] {
        guard let mateDictionary = try? mate.value() else { return [:] }
        return mateDictionary
    }
}
