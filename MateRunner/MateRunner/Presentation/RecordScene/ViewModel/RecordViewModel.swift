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
        let previousButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let cellDidTapEvent: Observable<Int>
    }
    
    struct Output {
        var timeText = BehaviorRelay<String>(value: "")
        var distanceText = BehaviorRelay<String>(value: "")
        var calorieText = BehaviorRelay<String>(value: "")
        var yearMonthDateText = BehaviorRelay<String>(value: "")
        var monthDayDateText = BehaviorRelay<String>(value: "")
        var runningCountText = BehaviorRelay<String>(value: "")
        var likeCountText = BehaviorRelay<String>(value: "")
        var calendarArray = BehaviorRelay<[CalendarModel?]>(value: [])
        var indicesToUpdate = BehaviorRelay<(Int?, Int?)>(value: (nil, nil))
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
        
        input.nextButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.updateMonth(toNext: true)
            })
            .disposed(by: disposeBag)
        
        input.previousButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.recordUseCase.updateMonth(toNext: false)
            })
            .disposed(by: disposeBag)
        
        input.cellDidTapEvent
            .compactMap { [weak self] index in
                self?.toDay(from: index)
            }
            .bind(to: self.recordUseCase.selectedDay)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func cellDidTap() {
        self.coordinator?.showDetailFlow()
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        self.bindCumulativeRecord(output: output, disposeBag: disposeBag)
        self.bindCalendar(output: output, disposeBag: disposeBag)
        
        self.recordUseCase.selectedDay
            .compactMap { $0?.toDateString(format: "MM월 dd일") }
            .bind(to: output.monthDayDateText)
            .disposed(by: disposeBag)
    }
    
    private func bindCumulativeRecord(output: Output, disposeBag: DisposeBag) {
        self.recordUseCase.time
            .map { $0.totalTimeString }
            .bind(to: output.timeText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.distance
            .map { $0.totalDistanceString }
            .bind(to: output.distanceText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.calorie
            .map { $0.totalCalorieString }
            .bind(to: output.calorieText)
            .disposed(by: disposeBag)
    }
    
    private func bindCalendar(output: Output, disposeBag: DisposeBag) {
        self.recordUseCase.month
            .compactMap { $0?.toDateString(format: "yyyy년 MM월") }
            .bind(to: output.yearMonthDateText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.runningCount
            .map { "\($0)" }
            .bind(to: output.runningCountText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.likeCount
            .map { "\($0)" }
            .bind(to: output.likeCountText)
            .disposed(by: disposeBag)
        
        self.recordUseCase.month
            .compactMap { [weak self] month in
                self?.generateCalendarArray(month: month)
            }
            .bind(to: output.calendarArray)
            .disposed(by: disposeBag)
        
        Observable.zip(self.recordUseCase.selectedDay, self.recordUseCase.selectedDay.skip(1))
            .map({ [weak self] (previousDay, currentDay) in
                (self?.toIndex(from: previousDay), self?.toIndex(from: currentDay))
            })
            .bind(to: output.indicesToUpdate)
            .disposed(by: disposeBag)
    }
    
    private func generateCalendarArray(month: Date?) -> [CalendarModel?] {
        guard let month = month,
              let selectedDay = try? self.recordUseCase.selectedDay.value()?.day else { return [] }

        let numOfDays = month.numberOfDays
        let startWeekday = month.weekday
        return [Int](0..<(numOfDays + startWeekday - 1)).map { index in
            let day = index - startWeekday + 2
            if day < 1 { return nil }
            let isSelected = (day == selectedDay)
            return CalendarModel(day: "\(day)", hasRecord: false, isSelected: isSelected)
        }
    }
    
    private func toIndex(from date: Date?) -> Int? {
        guard let date = date, let startWeekDay = date.startOfMonth?.weekday else { return nil }
        let index = date.day + startWeekDay - 2
        return index
    }
    
    private func toDay(from index: Int) -> Date? {
        guard let month = try? self.recordUseCase.month.value() else { return nil }
        let startWeekDay = month.weekday
        let integerDay = index - startWeekDay + 2
        
        guard integerDay >= 1 else { return nil }
        let day = month.setDay(to: integerDay)
        return day
    }
}
