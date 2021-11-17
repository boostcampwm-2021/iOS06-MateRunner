//
//  MateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//
import Foundation

import RxSwift

final class MateViewModel {
    private let mateUseCase: MateUseCase
    weak var coordinator: Coordinator?
    var mate: [String: String] = [:] // usecase에서 fetch 받고 순서맞춘 딕셔너리, 필터링 되는 것을 기준으로 잡을 원래의 딕셔너리
    var filteredMate: [String: String] = [:] // searchBar input으로 인해 필터링된 딕셔너리
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchBarEvent: Observable<String>
    }
    
    struct Output {
        @BehaviorRelayProperty var loadData: Bool = false
        @BehaviorRelayProperty var filterData: Bool = false
    }
    
    init(coordinator: Coordinator, mateUseCase: MateUseCase) {
         self.coordinator = coordinator
         self.mateUseCase = mateUseCase
     }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.mateUseCase.fetchMateInfo()
                self?.sortMate(from: self?.filteredMate ?? [:])
            })
            .disposed(by: disposeBag)
        
        input.searchBarEvent
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) // 0.5초동안 들어온 것중에 최신것을 방출
            .distinctUntilChanged() // 같은 값 들어오면 무시
            .subscribe(onNext: { [weak self] text in
                self?.filterText(from: text)
                self?.sortMate(from: self?.filteredMate ?? [:])
                output.filterData = true
            })
            .disposed(by: disposeBag)
        
        self.mateUseCase.mate
            .subscribe(onNext: { [weak self] mate in
                self?.mate = mate
                self?.filteredMate = mate // 초기에는 검색바가 비어있으니 필터링 된 내용이 없기때문에 초기와 동일하게
                self?.sortMate(from: self?.filteredMate ?? [:])
                output.loadData = true
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Private Functions
private extension MateViewModel {
    func filterText(from text: String) {
        self.filteredMate = self.mate.filter { key, _ in // 초기 mate를 기준으로 filter
            return key.hasPrefix(text)
        }
    }
    
    func sortMate(from mate: [String: String]) {
        if mate.isEmpty {
            return
        }
        let sortedMate = self.filteredMate.sorted(by: {$0.0 < $1.0})
        var tempDictionary = [String: String]()
        sortedMate.forEach {
            tempDictionary[$0.0] = $0.1
        }
        self.filteredMate = tempDictionary
    }
}
