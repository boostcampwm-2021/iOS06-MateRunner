//
//  RaceRunningResultViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/20.
//

import CoreLocation

import RxRelay
import RxSwift

final class RaceRunningResultViewModel {
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
        var dateTime: String
        var dayOfWeekAndTime: String
        var mode: String
        var distance: String
        var calorie: String
        var time: String
        var userNickname: String
        var mateDistance: String
        var headerMessage: String
        var resultMessage: String
        var points: [CLLocationCoordinate2D]
        var region: Region
        var selectedEmoji: PublishRelay<String> = PublishRelay<String>()
        var saveFailAlertShouldShow: PublishRelay<Bool> = PublishRelay<Bool>()
        var emojiModalShouldShow: PublishRelay<Bool>? = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
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
    
    func alertConfirmButtonDidTap() {
        self.coordinator?.finish()
    }
    
    private func createViewModelOutput() -> Output {
        let runningResult = self.runningResultUseCase.runningResult as? RaceRunningResult
        let errorAlternativeText = "---"
        
        let dateTime = runningResult?.dateTime ?? Date()
        let mode = runningResult?.mode ?? .single
        let coordinates = self.pointsToCoordinate2D(from: runningResult?.points ?? [])
        let userNickname = self.runningResultUseCase.fetchUserNickname() ?? errorAlternativeText
  
        let output = Output(
            dateTime: dateTime.fullDateTimeString(),
            dayOfWeekAndTime: dateTime.korDayOfTheWeekAndTimeString(),
            mode: mode.title,
            distance: runningResult?.userElapsedDistance.kilometerString ?? errorAlternativeText,
            calorie: String(Int(runningResult?.calorie ?? 0)),
            time: Date.secondsToTimeString(from: runningResult?.userElapsedTime ?? 0),
            userNickname: userNickname,
            mateDistance: runningResult?.mateElapsedDistance.string() ?? errorAlternativeText,
            headerMessage: self.createHeaderMessage(
                mateNickname: runningResult?.runningSetting.hostNickname ?? errorAlternativeText,
                isUserWinner: runningResult?.isUserWinner ?? false
            ),
            resultMessage: self.createResultMessage(
                isUserWinner: runningResult?.isUserWinner ?? false,
                userNickname: userNickname
            ),
            points: coordinates,
            region: self.calculateRegion(from: coordinates)
        )
        
        return output
    }
    
    private func createHeaderMessage(mateNickname: String, isUserWinner: Bool) -> String {
        return "\(mateNickname)와의 대결 \(isUserWinner ? "👑" : "😂")"
    }
    
    private func createResultMessage(isUserWinner: Bool, userNickname: String) -> String {
        return "\(userNickname)의 \(isUserWinner ? "승리" : "패배")!"
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
