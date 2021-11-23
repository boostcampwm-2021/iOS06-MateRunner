//
//  MateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//
import Foundation

import RxSwift
import RxRelay

final class MateViewModel {
    private let mateUseCase: MateUseCase
    weak var coordinator: MateCoordinator?
    
    typealias mateList = [(key: String, value: String)]
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBarTextEvent: Observable<String>
        let navigationButtonDidTapEvent: Observable<Void>
        let searchButtonDidTap: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var loadData: Bool = false
        @BehaviorRelayProperty var filterData: Bool = false
        var doneButtonDidTap = PublishRelay<Bool>()
        var filteredMateArray = PublishRelay<mateList>()
    }
    
    init(coordinator: MateCoordinator, mateUseCase: MateUseCase) {
         self.coordinator = coordinator
         self.mateUseCase = mateUseCase
     }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.mateUseCase.fetchMateInfo()
            })
            .disposed(by: disposeBag)
        
        input.searchBarTextEvent
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.mateUseCase.filteredMate(from: text)
                output.filterData = true
            })
            .disposed(by: disposeBag)
        
        input.navigationButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showAddMateFlow()
            })
            .disposed(by: disposeBag)
        
        input.searchButtonDidTap
            .subscribe(onNext: {
                output.doneButtonDidTap.accept(true)
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mate
            .bind(to: output.filteredMateArray)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func bindMate(output: Output, disposeBag: DisposeBag) {
        
    }
    
    func pushMateProfile(of nickname: String) {
        self.coordinator?.showMateProfileFlow(nickname)
    }
}
