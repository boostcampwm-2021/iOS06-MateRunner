//
//  StartViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/12/01.
//

import Foundation

import RxSwift

final class StartViewModel {
    private weak var startCoordinator: StartCoordinator?
    private let disposeBag = DisposeBag()
    
    init(startCoordinator: StartCoordinator) {
        self.startCoordinator = startCoordinator
    }
    
    struct Input {
        let signUpButtonDidTapEvent: Observable<Void>
        let loginEditButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.signUpButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.startCoordinator?.pushTermsViewController()
            })
            .disposed(by: self.disposeBag)
        
        input.loginEditButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.startCoordinator?.finish()
            })
            .disposed(by: self.disposeBag)
        
        return output
    }
}
