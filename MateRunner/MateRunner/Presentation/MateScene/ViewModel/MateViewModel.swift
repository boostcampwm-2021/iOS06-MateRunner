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
    var mate: [String: String] = [:] // usecase에서 fetch 받고 순서맞춘 딕셔너리, 필터링 되는 것을 기준으로 잡을 원래의 딕셔너리
    var filteredMate: [(key: String, value: String)] = []
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBarTextEvent: Observable<String>
        let navigationButtonDidTapEvent: Observable<Void>
        let searchButtonDidTap: Observable<Void>
    }
    
    struct Output {
        @BehaviorRelayProperty var loadData: Bool = false
        @BehaviorRelayProperty var filterData: Bool = false
        let doneButtonDidTap = PublishRelay<Bool>()
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
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) // 0.5초동안 들어온 것중에 최신것을 방출
            .distinctUntilChanged() // 같은 값 들어오면 무시
            .subscribe(onNext: { [weak self] text in
                self?.filterText(from: text)
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
            .subscribe(onNext: { [weak self] mate in
                self?.mate = mate
                self?.filteredMate = self?.sortedMate(list: mate) ?? []
                output.loadData = true
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func pushMateProfile(_ nickname: String) {
        self.coordinator?.showMateProfileFlow(nickname)
    }
}

// MARK: - Private Functions
private extension MateViewModel {
    func filterText(from text: String) {
        self.filteredMate = self.sortedMate(list: self.mate.filter { key, _ in // 초기 mate를 기준으로 filter
            return key.hasPrefix(text)
        })
    }
    
    func sortedMate(list: [String: String]) -> [(key: String, value: String)] {
        return list.sorted { $0.0 < $1.0 }
    }
}
