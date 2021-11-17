//
//  AddMateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import Foundation

import RxSwift

final class AddMateViewModel {
    private let mateUseCase: MateUseCase
    weak var coordinator: AddMateCoordinator?
    
    struct Input {
        let searchCompletedEvent: Observable<String>
    }
    
    struct Output {
    }
    
    init(coordinator: AddMateCoordinator, mateUseCase: MateUseCase) {
         self.coordinator = coordinator
         self.mateUseCase = mateUseCase
     }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        input.searchCompletedEvent
            .subscribe(onNext: { [weak self] text in
                //text 가지고 fetch..
                
            })
        
//        input.viewDidLoadEvent
//            .subscribe(onNext: { [weak self] in
//                self?.mateUseCase.fetchMateInfo()
//                self?.sortMate(from: self?.filteredMate ?? [:])
//            })
//            .disposed(by: disposeBag)
        
        
//        self.mateUseCase.mate
//            .subscribe(onNext: { [weak self] mate in
//                self?.mate = mate
//                self?.filteredMate = mate // 초기에는 검색바가 비어있으니 필터링 된 내용이 없기때문에 초기와 동일하게
//                self?.sortMate(from: self?.filteredMate ?? [:])
//                output.loadData = true
//            })
//            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Private Functions
private extension AddMateViewModel {
}
