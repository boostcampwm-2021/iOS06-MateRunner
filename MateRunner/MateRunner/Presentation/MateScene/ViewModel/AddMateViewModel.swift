//
//  AddMateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import Foundation

import RxSwift
import RxRelay

final class AddMateViewModel {
    private let mateUseCase: MateUseCase
    weak var coordinator: AddMateCoordinator?
    var mate: [String: String] = [:]
    
    struct Input {
        let searchCompletedEvent: Observable<Void>
        let searchBarEvent: Observable<String>
    }
    
    struct Output {
        let loadData = PublishRelay<[String: String]>()
    }
    
    init(coordinator: AddMateCoordinator, mateUseCase: MateUseCase) {
        self.coordinator = coordinator
        self.mateUseCase = mateUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        var text = ""
        
        input.searchCompletedEvent
            .subscribe(onNext: { [weak self] in
                print(text)
                self?.mateUseCase.fetchMateInfo(name: text)
            })
            .disposed(by: disposeBag)
        
        input.searchBarEvent
            .subscribe(onNext: { searchText in
                text = searchText
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mate
            .bind(to: output.loadData)
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Private Functions
private extension AddMateViewModel {
}
