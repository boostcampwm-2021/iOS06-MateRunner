//
//  TeamRunningResultViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/21.
//

import CoreLocation

import RxRelay
import RxSwift

final class TeamRunningResultViewModel: CoreLocationConvertable {
    private let runningResultUseCase: RunningResultUseCase
    private let errorAlternativeText = "---"
    weak var coordinator: RunningCoordinator?
    
    init(
        coordinator: RunningCoordinator?,
        runningResultUseCase: RunningResultUseCase
    ) {
        self.coordinator = coordinator
        self.runningResultUseCase = runningResultUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
        let emojiButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var dateTime: String
        var dayOfWeekAndTime: String
        var headerText: String
        var userDistance: String
        var calorie: String
        var time: String
        var userNickname: String
        var totalDistance: String
        var contributionRate: String
        var points: [CLLocationCoordinate2D]
        var region: Region
        var canceledResultShouldShow: Bool
        var selectedEmoji: PublishRelay<String> = PublishRelay<String>()
        var saveFailAlertShouldShow: PublishRelay<Bool> = PublishRelay<Bool>()
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
        
        input.emojiButtonDidTapEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.presentEmojiModal(connectedTo: self.runningResultUseCase)
            })
            .disposed(by: disposeBag)
        
        self.runningResultUseCase.selectedEmoji
            .map({ $0.text() })
            .bind(to: output.selectedEmoji)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func createViewModelOutput() -> Output {
        let runningResult = self.runningResultUseCase.runningResult as? TeamRunningResult

        let dateTime = runningResult?.dateTime ?? Date()
        let userDistance = runningResult?.userElapsedDistance.string() ?? self.errorAlternativeText
        
        let mateNickName = runningResult?.runningSetting.mateNickname ?? self.errorAlternativeText
        let calorie = runningResult?.calorie.calorieString ?? self.errorAlternativeText
        let userTime = runningResult?.userElapsedTime ?? 0
        let userNickname = runningResult?.resultOwner ?? self.errorAlternativeText
        let isCanceled = runningResult?.isCanceled ?? false
        let totalDistance = runningResult?.totalDistance.kilometerString ?? self.errorAlternativeText
        let contributionRate = runningResult?.contribution.percentageString ?? self.errorAlternativeText
        let coordinates = self.pointsToCoordinate2D(from: runningResult?.points ?? [])
        
        return Output(
            dateTime: dateTime.fullDateTimeString(),
            dayOfWeekAndTime: dateTime.korDayOfTheWeekAndTimeString(),
            headerText: self.createHeaderMessage(
                mateNickname: mateNickName
            ),
            userDistance: userDistance,
            calorie: calorie,
            time: Date.secondsToTimeString(
                from: userTime
            ),
            userNickname: userNickname,
            totalDistance: totalDistance,
            contributionRate: contributionRate,
            points: coordinates,
            region: self.calculateRegion(from: coordinates),
            canceledResultShouldShow: isCanceled
        )
    }
    
    private func createMateResult(isUserWinner: Bool, runningResult: RaceRunningResult?) -> String {
        return isUserWinner
        ? runningResult?.mateElapsedDistance.string() ?? self.errorAlternativeText
        : Date.secondsToTimeString(from: runningResult?.mateElapsedTime ?? 0)
    }
    
    private func createHeaderMessage(mateNickname: String) -> String {
        return "\(mateNickname) 메이트와 함께한 달리기"
    }
    
    private func requestSavingResult(viewModelOutput: Output, disposeBag: DisposeBag) {
        self.runningResultUseCase.saveRunningResult()
            .subscribe(onError: { _ in
                viewModelOutput.saveFailAlertShouldShow.accept(true)
            })
            .disposed(by: disposeBag)
    }
}
