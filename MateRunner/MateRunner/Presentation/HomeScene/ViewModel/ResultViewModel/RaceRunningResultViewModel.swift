//
//  RaceRunningResultViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/20.
//

import CoreLocation

import RxRelay
import RxSwift

final class RaceRunningResultViewModel: CoreLocationConvertable {
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
        var distance: String
        var calorie: String
        var time: String
        var userNickname: String
        var winnerText: String
        var mateResultValue: String
        var mateResultDescription: String
        var unitLabelShouldShow: Bool
        var points: [CLLocationCoordinate2D]
        var region: Region
        var canceledResultShouldShow: Bool
        var selectedEmoji = PublishRelay<String>()
        var saveFailAlertShouldShow = PublishRelay<Bool>()
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
            .subscribe(
            onNext: { [weak self] _ in
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
        let runningResult = self.runningResultUseCase.runningResult as? RaceRunningResult
        
        let dateTime = runningResult?.dateTime ?? Date()
        let coordinates = self.pointsToCoordinate2D(from: runningResult?.points ?? [])
        let userNickname = runningResult?.resultOwner ?? self.errorAlternativeText
        let isUserWinner = runningResult?.isUserWinner ?? false
        let isCanceled = runningResult?.isCanceled ?? false
        let userDistance = runningResult?.userElapsedDistance.string() ?? self.errorAlternativeText
        let userTime = runningResult?.userElapsedTime ?? 0
        let mateNickName = runningResult?.runningSetting.mateNickname ?? self.errorAlternativeText
        let calorie = runningResult?.calorie.calorieString ?? self.errorAlternativeText

        return Output(
            dateTime: dateTime.fullDateTimeString(),
            dayOfWeekAndTime: dateTime.korDayOfTheWeekAndTimeString(),
            headerText: self.createHeaderMessage(
                mateNickname: mateNickName,
                isUserWinner: isUserWinner,
                isCanceled: isCanceled
            ),
            distance: userDistance,
            calorie: calorie,
            time: Date.secondsToTimeString(
                from: userTime
            ),
            userNickname: userNickname,
            winnerText: self.createResultMessage(
                isUserWinner: isUserWinner,
                userNickname: userNickname
            ),
            mateResultValue: self.createMateResult(
                isUserWinner: isUserWinner,
                runningResult: runningResult
            ),
            mateResultDescription: self.createMateResultText(
                isUserWinner: isUserWinner
            ),
            unitLabelShouldShow: isUserWinner,
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
    
    private func createMateResultText(isUserWinner: Bool) -> String {
        return isUserWinner ?  "메이트가 달린 거리" : "메이트가 완주한 시간"
    }
    
    private func createHeaderMessage(mateNickname: String, isUserWinner: Bool, isCanceled: Bool) -> String {
        guard isCanceled == false else { return "\(mateNickname) 메이트와의 대결" }
        return "\(mateNickname) 메이트와의 대결 \(isUserWinner ? "👑" : "😂")"
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
}
