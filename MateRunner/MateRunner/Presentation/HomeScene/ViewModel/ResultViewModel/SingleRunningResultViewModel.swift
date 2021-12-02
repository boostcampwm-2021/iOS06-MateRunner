//
//  SingleRunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxRelay
import RxSwift

final class SingleRunningResultViewModel {
    private let runningResultUseCase: RunningResultUseCase
    weak var coordinator: RunningCoordinator?
    
    init(coordinator: RunningCoordinator?, runningResultUseCase: RunningResultUseCase) {
        self.coordinator = coordinator
        self.runningResultUseCase = runningResultUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var dateTime: String
        var dayOfWeekAndTime: String
        var headerText: String
        var distance: String
        var calorie: String
        var time: String
        var points: [CLLocationCoordinate2D]
        var region: Region
        var saveFailAlertShouldShow = PublishRelay<Bool>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = self.createViewModelOutput()
        
        input.viewDidLoadEvent.subscribe(
            onNext: { [weak self] _ in
                self?.requestSavingResult(viewModelOutput: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTapEvent.subscribe(
            onNext: { [weak self] _ in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func createViewModelOutput() -> Output {
        let runningResult = self.runningResultUseCase.runningResult
        
        let dateTime = runningResult.dateTime ?? Date()
        let coordinates = self.pointsToCoordinate2D(from: runningResult.points)
        let userDistance = runningResult.userElapsedDistance.string()
        let userTime = runningResult.userElapsedTime
        let calorie = String(Int(runningResult.calorie))
        
        return Output(
            dateTime: dateTime.fullDateTimeString(),
            dayOfWeekAndTime: dateTime.korDayOfTheWeekAndTimeString(),
            headerText: "혼자 달리기",
            distance: userDistance,
            calorie: calorie,
            time: Date.secondsToTimeString(
                from: userTime
            ),
            points: coordinates,
            region: self.calculateRegion(from: coordinates)
        )
    }
    
    private func requestSavingResult(viewModelOutput: Output, disposeBag: DisposeBag) {
        self.runningResultUseCase.saveRunningResult()
            .subscribe(onError: { _ in
                viewModelOutput.saveFailAlertShouldShow.accept(true)
            })
            .disposed(by: disposeBag)
    }
  
    private func pointsToCoordinate2D(from points: [Point]) -> [CLLocationCoordinate2D] {
        return points.map { location in location.convertToCLLocationCoordinate2D() }
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
}
