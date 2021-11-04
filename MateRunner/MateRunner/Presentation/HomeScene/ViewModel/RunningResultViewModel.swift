//
//  RunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxCocoa
import RxSwift

final class RunningResultViewModel {
    // let runningResultUseCase: RunningResultUseCase = RunningResultUseCase()
    private var runningResult: RunningResult? = RunningResult(
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
    
//    init(runningResult: RunningResult) {
//        self.runningResult = runningResult
//    }
    
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        @BehaviorRelayProperty var dateTime: String?
        @BehaviorRelayProperty var korDateTime: String?
        @BehaviorRelayProperty var mode: String?
        @BehaviorRelayProperty var distance: String?
        @BehaviorRelayProperty var kcal: String?
        @BehaviorRelayProperty var time: String?
        @BehaviorRelayProperty var points: [CLLocationCoordinate2D] = []
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let result = input.load.map { self.runningResult }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd - HH:mm"
        
        let weekdays = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
        
        result.map { $0?.runningSetting.dateTime ?? Date() }
        .map { formatter.string(from: $0) }
        .drive(output.$dateTime)
        .disposed(by: disposeBag)
        
        result.map { $0?.runningSetting.dateTime ?? Date() }
        .map { Calendar.current.component(.weekday, from: $0) }
        .map { weekdays[$0 - 1] }
        .drive(output.$korDateTime)
        .disposed(by: disposeBag)
        
        result.map { $0?.runningSetting.mode }
        .map { $0?.title }
        .drive(output.$mode)
        .disposed(by: disposeBag)
        
        result.map { $0?.userElapsedDistance }
        .map { "\($0 ?? 0)" }
        .drive(output.$distance)
        .disposed(by: disposeBag)
        
        result.map { $0?.kcal }
        .map { "\($0 ?? 0)" }
        .drive(output.$kcal)
        .disposed(by: disposeBag)
        
        result.map { $0?.userElapsedTime }
        .map { "\($0 ?? 0)" }
        .drive(output.$time)
        .disposed(by: disposeBag)
        
        result.map { $0?.points ?? [] }
        .map { $0.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) } }
        .drive(output.$points)
        .disposed(by: disposeBag)
        
        return output
    }
}
