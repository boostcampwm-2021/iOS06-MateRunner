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
    typealias MateList = [(key: String, value: String)]
    var filteredMate: MateList = []
    
    struct Input {
        let searchButtonDidTap: Observable<Void>
        let searchBarTextEvent: Observable<String>
    }
    
    struct Output {
        let loadData = PublishRelay<Bool>()
    }
    
    init(coordinator: AddMateCoordinator, mateUseCase: MateUseCase) {
        self.coordinator = coordinator
        self.mateUseCase = mateUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        var text = ""
        
        input.searchButtonDidTap
            .subscribe(onNext: { [weak self] in
                self?.mateUseCase.fetchSearchMate(name: text)
            })
            .disposed(by: disposeBag)
        
        input.searchBarTextEvent
            .subscribe(onNext: { searchText in
                text = searchText
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mateList
            .subscribe(onNext: { [weak self] mate in
                self?.filteredMate = mate
                output.loadData.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func requestMate(to mate: String) {
        self.mateUseCase.sendRequestMate(to: mate)
    }
}
