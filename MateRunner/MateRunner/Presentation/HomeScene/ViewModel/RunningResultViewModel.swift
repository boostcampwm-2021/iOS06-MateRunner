//
//  RunningResultViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/02.
//

import CoreLocation

import RxRelay
import RxSwift

final class RunningResultViewModel {
    private let runningResultUseCase: RunningResultUseCase
    weak var coordinator: RunningCoordinator?
    
    init(coordinator: RunningCoordinator, runningResultUseCase: RunningResultUseCase) {
        self.coordinator = coordinator
        self.runningResultUseCase = runningResultUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var dateTime = BehaviorRelay<String>(value: "")
        var dayOfWeekAndTime = BehaviorRelay<String>(value: "")
        var mode = BehaviorRelay<String>(value: "")
        var distance = BehaviorRelay<String>(value: "")
        var calorie = BehaviorRelay<String>(value: "")
        var time = BehaviorRelay<String>(value: "")
        var points = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
        var region = BehaviorRelay<Region>(value: Region())
        var saveFailAlertShouldShow = PublishRelay<Bool>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let runningResult = self.runningResultUseCase.runningResult
        let output = Output()
        
        guard let dateTime = runningResult.dateTime,
              let mode = runningResult.mode else { return Output() }
        let coordinates = self.pointsToCoordinate2D(from: runningResult.points)
        
        input.viewDidLoadEvent.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            output.calorie.accept(String(Int(runningResult.calorie)))
            output.dateTime.accept(dateTime.fullDateTimeString())
            output.dayOfWeekAndTime.accept(dateTime.korDayOfTheWeekAndTimeString())
            output.mode.accept(mode.title)
            output.distance.accept(self.convertToKilometerText(from: runningResult.userElapsedDistance))
            output.time.accept(Date.secondsToTimeString(from: runningResult.userElapsedTime))
            output.points.accept(coordinates)
            output.region.accept(self.calculateRegion(from: coordinates))
        })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTapEvent.subscribe(
            onNext: { [weak self] _ in
                self?.closeButtonDidTap(viewModelOutput: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func alertConfirmButtonDidTap() {
        self.coordinator?.finish()
    }
    
    private func closeButtonDidTap(viewModelOutput: Output, disposeBag: DisposeBag) {
        self.runningResultUseCase.saveRunningResult()
            .subscribe(onNext: { [weak self] isSaveSuccess in
                if isSaveSuccess {
                    self?.coordinator?.finish()
                } else {
                    viewModelOutput.saveFailAlertShouldShow.accept(true)
                }
            }, onError: { _ in
                viewModelOutput.saveFailAlertShouldShow.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func convertToKilometerText(from value: Double) -> String {
        return String(format: "%.2f", round(value / 10) / 100)
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
