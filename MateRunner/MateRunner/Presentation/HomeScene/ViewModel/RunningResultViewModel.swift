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
        var dateTime: BehaviorRelay<String>
        var dayOfWeekAndTime: BehaviorRelay<String>
        var mode: BehaviorRelay<String>
        var distance: BehaviorRelay<String>
        var calorie: BehaviorRelay<String>
        var time: BehaviorRelay<String>
        var points: BehaviorRelay<[CLLocationCoordinate2D]>
        var region: BehaviorRelay<Region>
        var saveFailAlertShouldShow: PublishRelay<Bool>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let runningResult = self.runningResultUseCase.runningResult
        
        let dateTime = runningResult.dateTime ?? Date()
        let mode = runningResult.mode ?? .single
        let coordinates = self.pointsToCoordinate2D(from: runningResult.points)
        
        let output = Output(
            dateTime: BehaviorRelay(value: dateTime.fullDateTimeString()),
            dayOfWeekAndTime: BehaviorRelay(value: dateTime.korDayOfTheWeekAndTimeString()),
            mode: BehaviorRelay(value: mode.title),
            distance: BehaviorRelay(value: self.convertToKilometerText(
                from: runningResult.userElapsedDistance
            )),
            calorie: BehaviorRelay(value: String(Int(runningResult.calorie))),
            time: BehaviorRelay(value: Date.secondsToTimeString(from: runningResult.userElapsedTime)),
            points: BehaviorRelay(value: coordinates),
            region: BehaviorRelay(value: self.calculateRegion(from: coordinates)),
            saveFailAlertShouldShow: PublishRelay<Bool>()
        )
        
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
    
    func alertConfirmButtonDidTap() {
        self.coordinator?.finish()
    }
    
    private func requestSavingResult(viewModelOutput: Output, disposeBag: DisposeBag) {
        self.runningResultUseCase.saveRunningResult()
            .subscribe(onError: { _ in
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
