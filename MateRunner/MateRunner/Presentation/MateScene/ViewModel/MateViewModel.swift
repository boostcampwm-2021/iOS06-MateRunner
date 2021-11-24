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
    typealias MateList = [(key: String, value: String)]
    private let mateUseCase: MateUseCase
    weak var coordinator: MateCoordinator?
    var mate: MateList?
    var filteredMate: MateList?
    private(set) var initialLoad = true
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBarTextEvent: Observable<String>
        let navigationButtonDidTapEvent: Observable<Void>
        let searchButtonDidTap: Observable<Void>
    }
    
    struct Output {
        var loadData = PublishRelay<Bool>()
        var filterData = PublishRelay<Bool>()
        var doneButtonDidTap = PublishRelay<Bool>()
    }
    
    init(coordinator: MateCoordinator, mateUseCase: MateUseCase) {
         self.coordinator = coordinator
         self.mateUseCase = mateUseCase
     }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.mateUseCase.fetchMateList()
            })
            .disposed(by: disposeBag)
        
        input.searchBarTextEvent
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.mateUseCase.filteredMate(base: self?.mate ?? [], from: text)
                output.filterData.accept(true)
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
            .subscribe(onNext: { [weak self] mate in
                if self?.initialLoad ?? true {
                    self?.mate = mate
                }
                self?.filteredMate = mate
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.didLoadMate
            .filter { $0 }
            .subscribe(onNext: { _ in
                output.loadData.accept(true)
                self.initialLoad = false
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func pushMateProfile(of nickname: String) {
        self.coordinator?.showMateProfileFlow(nickname)
    }
}
