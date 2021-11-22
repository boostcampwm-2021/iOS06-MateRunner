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
    var mate: [(key: String, value: String)] = []
    
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
                self?.mateUseCase.fetchMateInfo(name: text)
            })
            .disposed(by: disposeBag)
        
        input.searchBarTextEvent
            .subscribe(onNext: { searchText in
                text = searchText
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mate
            .subscribe(onNext: { [weak self] mate in
                self?.mate = self?.sortedMate(list: mate) ?? []
                output.loadData.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func requestMate(to mate: String) {
        self.mateUseCase.sendRequestMate(to: mate)
    }
}

// MARK: - Private Functions
private extension AddMateViewModel {
    func sortedMate(list: [String: String]) -> [(key: String, value: String)] {
        return list.sorted { $0.0 < $1.0 }
    }
}
