//
//  RecordDetailViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import CoreLocation

import RxSwift

final class RecordDetailViewModel {
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
        
        let userNickname = self.recordDetailUseCase.fetchUserNickname() ?? ""
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
            userNickname: userNickname,
            emojiList: self.countedEmojiList(from: runningResult.emojis)
        )
        
        if let raceRunningResult = runningResult as? RaceRunningResult {
            output.headerText = self.createHeaderMessage(
                mateNickname: raceRunningResult.runningSetting.mateNickname ?? "",
                isUserWinner: raceRunningResult.isUserWinner,
                shouldShowEmoji: !raceRunningResult.isCanceled
            )
            output.winnerText = self.createResultMessage(
                isUserWinner: raceRunningResult.isUserWinner,
                userNickname: userNickname
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
                shouldShowEmoji: false
            )
            output.totalDistance = teamRunningResult.totalDistance.kilometerString
            output.contributionRate = teamRunningResult.contribution.percentageString
        }
        
        return output
    }
}

private extension RecordDetailViewModel {
    func pointsToCoordinate2D(from points: [Point]) -> [CLLocationCoordinate2D] {
        return points.map { location in location.convertToCLLocationCoordinate2D() }
    }
    
    func calculateRegion(from points: [CLLocationCoordinate2D]) -> Region {
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
    
    func createHeaderMessage(mateNickname: String, isUserWinner: Bool, shouldShowEmoji: Bool) -> String {
        if shouldShowEmoji {
            return "\(mateNickname) 메이트와의 대결 \(isUserWinner ? "👑" : "😂")"
        } else {
            return "\(mateNickname) 메이트와의 대결"
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
    
