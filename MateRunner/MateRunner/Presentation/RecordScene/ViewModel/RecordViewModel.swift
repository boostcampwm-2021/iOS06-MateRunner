//
//  RecordViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

import RxCocoa
import RxSwift

final class RecordViewModel {
    private weak var coordinator: RecordCoordinator?
    private let recordUseCase: RecordUseCase
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var timeText = BehaviorRelay<String>(value: "")
        var distanceText = BehaviorRelay<String>(value: "")
        var calorieText = BehaviorRelay<String>(value: "")
        var yearMonthDateText = BehaviorRelay<String>(value: "")
        var monthDayDateText = BehaviorRelay<String>(value: "")
        var runningCountText = BehaviorRelay<String>(value: "")
        var likeCountText = BehaviorRelay<String>(value: "")
    }
    
    init(coordinator: RecordCoordinator, recordUsecase: RecordUseCase) {
        self.coordinator = coordinator
        self.recordUseCase = recordUsecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.loadCumulativeRecord()
                self?.recordUseCase.loadMonthRecord()
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        self.recordUseCase.time
            .map { $0.toTimeString() }
            .bind(to: output.timeText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.distance
            .map { $0.toDistanceString() }
            .bind(to: output.distanceText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.calorie
            .map { $0.toCalorieString() }
            .bind(to: output.calorieText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.date
            .map { $0.toDateString(format: "yyyy년 MM월") }
            .bind(to: output.yearMonthDateText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.date
            .map { $0.toDateString(format: "MM월 dd일") }
            .bind(to: output.monthDayDateText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.runningCount
            .map { "\($0)" }
            .bind(to: output.runningCountText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.likeCount
            .map { "\($0)" }
            .bind(to: output.likeCountText)
            .disposed(by: disposeBag)
    }
}
