//
//  RunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxRelay
import RxSwift


struct Region {
    private(set) var center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private(set) var span: (Double, Double) = (0, 0)
}

final class RunningResultViewModel {
    private let runningResultUseCase: RunningResultUseCase
    
    init(runningResultUseCase: RunningResultUseCase) {
        self.runningResultUseCase = runningResultUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
    }

    struct Output {
        var dateTime: PublishRelay<String>
        var korDateTime: PublishRelay<String>
        var mode: PublishRelay<String>
        var distance: PublishRelay<String>
        var calorie: PublishRelay<String>
        var time: PublishRelay<String>
        var isClosable: PublishRelay<Bool>
        @BehaviorRelayProperty var points: [CLLocationCoordinate2D] = []
        @BehaviorRelayProperty var region: Region = Region()
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
        let output = Output(
            dateTime: PublishRelay<String>(),
            korDateTime: PublishRelay<String>(),
            mode: PublishRelay<String>(),
            distance: PublishRelay<String>(),
            calorie: PublishRelay<String>(),
            time: PublishRelay<String>(),
            isClosable: PublishRelay<Bool>()
        )
        
        let result = input.viewDidLoadEvent.map { self.runningResult }
        
        result.map { $0.runningSetting.dateTime ?? Date() }
        .map { $0.fullDateTimeString() }
        .bind(to: output.dateTime)
        .disposed(by: disposeBag)
        
        result.map { $0.runningSetting.dateTime ?? Date() }
        .map { $0.korDayOfTheWeekAndTimeString() }
        .bind(to: output.korDateTime)
        .disposed(by: disposeBag)
        
        result.map { $0.runningSetting.mode ?? .single }
        .map { $0.title }
        .bind(to: output.mode)
        .disposed(by: disposeBag)
        
        result.map { $0.userElapsedDistance }
        .map { String(format: "%.2f", $0) }
        .bind(to: output.distance)
        .disposed(by: disposeBag)
        
        result.map { $0.calorie }
        .map { "\(Int($0 ) )" }
        .bind(to: output.calorie)
        .disposed(by: disposeBag)
        
        result.map { $0.userElapsedTime }
        .map { Date.secondsToTimeString(from: $0) }
        .bind(to: output.time)
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
        
        input.closeButtonDidTapEvent
            .flatMapLatest { [weak self] _ in
                self?.runningResultUseCase.saveRunningResult(self?.runningResult) ?? Observable.of(false)
            }
            .catchAndReturn(false)
            .bind(to: output.isClosable)
            .disposed(by: disposeBag)
        
        return output
    }
}
