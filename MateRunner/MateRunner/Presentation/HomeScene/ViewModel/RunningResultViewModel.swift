//
//  RunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxSwift

let mockResult = RunningResult(
    runningSetting:
        RunningSetting(
        mode: .single,
        targetDistance: 5.0,
        mateNickname: nil,
        dateTime: Date()
        ),
    userElapsedDistance: 5.0,
    userElapsedTime: 1200,
    kcal: 200,
    points: [
        Point(latitude: 37.785834, longitude: -122.406417),
        Point(latitude: 37.785855, longitude: -122.406466),
        Point(latitude: 37.785777, longitude: -122.405000),
        Point(latitude: 37.785111, longitude: -122.406411),
        Point(latitude: 37.785700, longitude: -122.405022)
    ],
    emojis: [:],
    isCanceled: false
)

final class RunningResultViewModel {
    let runningResultUseCase: RunningResultUseCase = DefaultRunningResultUseCase()

    private var runningResult = mockResult
    
//    init(runningResult: RunningResult) {
//        self.runningResult = runningResult
//    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonTapEvent: Observable<Void>
    }

    struct Output {
        @BehaviorRelayProperty var dateTime: String?
        @BehaviorRelayProperty var korDateTime: String?
        @BehaviorRelayProperty var mode: String?
        @BehaviorRelayProperty var distance: String?
        @BehaviorRelayProperty var kcal: String?
        @BehaviorRelayProperty var time: String?
        @BehaviorRelayProperty var points: [CLLocationCoordinate2D] = []
        @BehaviorRelayProperty var isClosable: Bool?
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let result = input.viewDidLoadEvent.map { self.runningResult }
        
        result.map { $0.runningSetting.dateTime ?? Date() }
        .map { $0.fullDateTimeString() }
        .bind(to: output.$dateTime)
        .disposed(by: disposeBag)
        
        result.map { $0.runningSetting.dateTime ?? Date() }
        .map { $0.korDayOfTheWeekAndTimeString() }
        .bind(to: output.$korDateTime)
        .disposed(by: disposeBag)
        
        result.map { $0.runningSetting.mode }
        .map { $0?.title }
        .bind(to: output.$mode)
        .disposed(by: disposeBag)
        
        result.map { $0.userElapsedDistance }
        .map { String(format: "%.2f", $0) }
        .bind(to: output.$distance)
        .disposed(by: disposeBag)
        
        result.map { $0.kcal }
        .map { "\(Int($0 ) )" }
        .bind(to: output.$kcal)
        .disposed(by: disposeBag)
        
        result.map { $0.userElapsedTime }
        .map { Date.secondsToTimeString(from: $0) }
        .bind(to: output.$time)
        .disposed(by: disposeBag)
        
        result.map { $0.points }
        .map { $0.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) } }
        .bind(to: output.$points)
        .disposed(by: disposeBag)
        
        input.closeButtonTapEvent
            .flatMapLatest { [weak self] _ in
                self?.runningResultUseCase.saveRunningResult(self?.runningResult) ?? Observable.of(false)
            }
            .bind(to: output.$isClosable)
            .disposed(by: disposeBag)
        
        return output
    }
}
