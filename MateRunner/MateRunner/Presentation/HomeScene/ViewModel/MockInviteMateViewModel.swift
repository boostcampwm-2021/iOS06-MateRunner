//
//  MockInviteMateViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

final class MockInviteMateViewModel {
    private let useCase = DefaultMockInviteMateUseCase()
    
    struct Input {
        let mateButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var requestSuccess: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.mateButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.useCase.inviteMate("jk")
            })
            .disposed(by: disposeBag)
        
        self.useCase.requestSuccess
            .bind(to: output.requestSuccess)
            .disposed(by: disposeBag)
        
        self.useCase.isAccepted.subscribe { (isRecieved, isAccepted) in
            print(isRecieved, isAccepted)
        }.disposed(by: disposeBag)
        
        return output
    }
}
