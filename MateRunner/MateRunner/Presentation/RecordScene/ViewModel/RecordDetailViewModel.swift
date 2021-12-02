//
//  RecordDetailViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import CoreLocation

import RxSwift

final class RecordDetailViewModel: CoreLocationConvertable {
    private let recordDetailUseCase: RecordDetailUseCase

    struct Output {
        var runningMode: RunningMode?
        var dateTime: String
        var dayOfWeekAndTime: String
        var headerText: String
        var distance: String
        var calorie: String
        var time: String
        var points: [CLLocationCoordinate2D]
        var region: Region
        var isCanceled: Bool
        var userNickname: String
        var emojiList: [String: String]?
        var winnerText: String?
        var mateResultValue: String?
        var mateResultDescription: String?
        var unitLabelShouldShow: Bool?
        var totalDistance: String?
        var contributionRate: String?
    }
    
    init(recordDetailUseCase: RecordDetailUseCase) {
        self.recordDetailUseCase = recordDetailUseCase
    }
    
    func createViewModelOutput() -> Output {
        let runningResult = self.recordDetailUseCase.runningResult
        let coordinates = self.pointsToCoordinate2D(from: runningResult.points)
        
        var output = Output(
            runningMode: runningResult.mode,
            dateTime: runningResult.dateTime?.fullDateTimeString() ?? "",
            dayOfWeekAndTime: runningResult.dateTime?.korDayOfTheWeekAndTimeString() ?? "",
            headerText: "혼자 달리기",
            distance: runningResult.userElapsedDistance.kilometerString,
            calorie: runningResult.calorie.calorieString,
            time: runningResult.userElapsedTime.timeString,
            points: coordinates,
            region: self.calculateRegion(from: coordinates),
            isCanceled: runningResult.isCanceled,
            userNickname: runningResult.resultOwner,
            emojiList: self.countedEmojiList(from: runningResult.emojis)
        )
        
        if let raceRunningResult = runningResult as? RaceRunningResult {
            output.headerText = self.createHeaderMessage(
                mateNickname: raceRunningResult.runningSetting.mateNickname ?? "",
                isUserWinner: raceRunningResult.isUserWinner,
                isRaceMode: true,
                isCanceled: raceRunningResult.isCanceled
            )
            output.winnerText = self.createResultMessage(
                isUserWinner: raceRunningResult.isUserWinner,
                userNickname: runningResult.resultOwner
            )
            output.mateResultValue = self.createMateResult(
                isUserWinner: raceRunningResult.isUserWinner,
                runningResult: raceRunningResult
            )
            output.mateResultDescription = self.createMateResultText(isUserWinner: raceRunningResult.isUserWinner)
            output.unitLabelShouldShow = raceRunningResult.isUserWinner
        } else if let teamRunningResult = runningResult as? TeamRunningResult {
            output.headerText = self.createHeaderMessage(
                mateNickname: teamRunningResult.runningSetting.mateNickname ?? "",
                isUserWinner: false,
                isRaceMode: false,
                isCanceled: teamRunningResult.isCanceled
            )
            output.totalDistance = teamRunningResult.totalDistance.kilometerString
            output.contributionRate = teamRunningResult.contribution.percentageString
        }
        
        return output
    }
}

private extension RecordDetailViewModel {
    func createHeaderMessage(
        mateNickname: String,
        isUserWinner: Bool,
        isRaceMode: Bool,
        isCanceled: Bool
    ) -> String {
        if isRaceMode {
            return isCanceled ? "\(mateNickname) 메이트와의 대결"
            : "\(mateNickname) 메이트와의 대결 \(isUserWinner ? "👑" : "😂")"
        } else {
            return "\(mateNickname) 메이트와 함께한 달리기"
        }
    }
    
    func createResultMessage(isUserWinner: Bool, userNickname: String) -> String {
        return "\(userNickname)의 \(isUserWinner ? "승리" : "패배")!"
    }
    
    func createMateResult(isUserWinner: Bool, runningResult: RaceRunningResult?) -> String {
        return isUserWinner
        ? runningResult?.mateElapsedDistance.kilometerString ?? ""
        : runningResult?.mateElapsedTime.timeString ?? ""
    }
    
    func createMateResultText(isUserWinner: Bool) -> String {
        return isUserWinner ?  "메이트가 달린 거리" : "메이트가 완주한 시간"
    }
    
    func countedEmojiList(from emojis: [String: Emoji]?) -> [String: String]? {
        guard let emojis = emojis,
              emojis.count > 0 else { return nil }
        
        var emojiList: [String: String] = [:]
        Emoji.allCases.forEach { emoji in
            let count = emojis.filter { $0.value == emoji }.count
            if count > 0 { emojiList[emoji.text()] = "\(count)" }
        }
        return emojiList
    }
}
    
