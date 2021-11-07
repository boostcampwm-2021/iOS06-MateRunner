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

struct Region {
    private(set) var center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private(set) var span: (Double, Double) = (0, 0)
}

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
        @BehaviorRelayProperty var region: Region = Region()
        @BehaviorRelayProperty var isClosable: Bool?
    }
    
    private func calculateRegion(from points: [CLLocationCoordinate2D]) -> Region {
        guard !points.isEmpty else { return Region() }

        let latitudes = points.map { $0.latitude }
        let longitudes = points.map { $0.longitude }
        
        guard let maxLatitude = latitudes.max(),
              let minLatitude = latitudes.min(),
              let maxLongitude = longitudes.max(),
              let minLongitude = longitudes.min() else { return Region() }

        let meanLatitude = (maxLatitude + minLatitude) / 2
        let meanLongitude = (maxLongitude + minLongitude) / 2
        let coordinate = CLLocationCoordinate2DMake(meanLatitude, meanLongitude)
        
        let latitudeSpan = (maxLatitude - minLatitude) * 1.5
        let longitudeSpan = (maxLongitude - minLongitude) * 1.5
        let span = (latitudeSpan, longitudeSpan)
        
        return Region(center: coordinate, span: span)
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
        
        result.map { $0.points }
        .map { $0.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) } }
        .map { self.calculateRegion(from: $0) }
        .bind(to: output.$region)
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
