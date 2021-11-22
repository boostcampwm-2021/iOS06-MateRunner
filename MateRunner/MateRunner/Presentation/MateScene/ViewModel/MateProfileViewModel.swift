//
//  MateProfileViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import Foundation

import RxRelay
import RxSwift

final class MateProfileViewModel: NSObject {
    private let mateUseCase: MateUseCase
    weak var coordinator: MateProfileCoordinator?
    // var mateInfo: UserProfileInfo? // TODO: 정보 담을 구조체 정의
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        // TODO: output 정의
//        let loadData = PublishRelay<Bool>()
    }
    
    init(coordinator: MateProfileCoordinator, mateUseCase: MateUseCase) {
        self.coordinator = coordinator
        self.mateUseCase = mateUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                // mateInfo에 있는 닉네임 가지고 메이트 정보 User 컬렉션 fetch
                // mateInfo에 있는 닉네임 가지고 메이트 정보 RunningResult 컬렉션 fetch
            })
            .disposed(by: disposeBag)

        // TODO: output 정의
//        self.mateUseCase.mate
//            .subscribe(onNext: { [weak self] mate in
//                self.mateInfo = mate
//                output.loadData.accept(true)
//            })
//            .disposed(by: disposeBag)
        
        return output
    }
}
