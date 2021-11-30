//
//  TermsViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/30.
//

import Foundation

import RxRelay
import RxSwift

final class TermsViewModel {
    private weak var startCoordinator: StartCoordinator?
    private let disposeBag = DisposeBag()
    
    init(
        startCoordinator: StartCoordinator
    ) {
        self.startCoordinator = startCoordinator
    }
    
    struct Input {
        let agreeButtonDidTapEvent: Observable<Void>
        let disagreeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var isDisagreed = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.agreeButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.startCoordinator?.finish()
            })
            .disposed(by: self.disposeBag)
        
        input.disagreeButtonDidTapEvent
            .subscribe(onNext: { _ in
                output.isDisagreed.accept(true)
            })
            .disposed(by: self.disposeBag)
        
        return output
    }
}
