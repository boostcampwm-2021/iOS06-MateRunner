import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct RunningResultDTO: Codable {
    private(set) var mode: String
    private(set) var targetDistance: Double
    private(set) var mateNickname: String?
    private(set) var dateTime: Date
    private(set) var userElapsedDistance: Double = 0
    private(set) var userElapsedTime: Int = 0
    private(set) var mateElapsedDistance: Double?
    private(set) var mateElapsedTime: Int?
    private(set) var calorie: Double = 0
    private(set) var points: [GeoPoint] = []
    private(set) var emojis: [String: String] = [:]
    private(set) var isCanceled: Bool = false
    
    init(from domain: RunningResult) {
        let runningSetting = domain.runningSetting
        
        self.targetDistance = runningSetting.targetDistance ?? 0
        self.mateNickname = runningSetting.mateNickname
        self.dateTime = runningSetting.dateTime ?? Date()
        self.userElapsedDistance = domain.userElapsedDistance
        self.userElapsedTime = domain.userElapsedTime
        self.calorie = domain.calorie
        self.points = domain.points.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) }
        self.emojis = domain.emojis?.mapValues { $0.text() } ?? [:]
        self.isCanceled = domain.isCanceled
        
        if let raceRunningResult = domain as? RaceRunningResult {
            self.mode = runningSetting.mode?.title ?? RunningMode.race.title
            self.mateElapsedDistance = raceRunningResult.mateElapsedDistance
            self.mateElapsedTime = raceRunningResult.mateElapsedTime
        } else if let teamRunningResult = domain as? TeamRunningResult {
            self.mode = runningSetting.mode?.title ?? RunningMode.team.title
            self.mateElapsedDistance = teamRunningResult.mateElapsedDistance
            self.mateElapsedTime = teamRunningResult.mateElapsedTime
        } else {
            self.mode = runningSetting.mode?.title ?? RunningMode.single.title
            self.mateElapsedDistance = nil
            self.mateElapsedTime = nil
        }
    }
}

extension RunningResultDTO {
    func toDomain() -> RunningResult {
        let runningSetting = RunningSetting(
            mode: RunningMode(rawValue: self.mode),
            targetDistance: self.targetDistance,
            mateNickname: self.mateNickname,
            dateTime: self.dateTime
        )
        
        let tempEmoji = self.emojis.mapValues { Emoji(rawValue: $0) ?? .clap }
        guard let mode = RunningMode(rawValue: self.mode) else {
            return RunningResult(
                userNickname: "",
                runningSetting: RunningSetting(),
                userElapsedDistance: 0,
                userElapsedTime: 0,
                calorie: 0,
                points: [],
                emojis: [:],
                isCanceled: false
            )
        }
        
        switch mode {
        case .single:
            return RunningResult(
                userNickname: "temp",
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                calorie: self.calorie,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: tempEmoji,
                isCanceled: self.isCanceled
            )
        case .race:
            return RaceRunningResult(
                userNickname: "temp",
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                calorie: self.calorie,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: tempEmoji,
                isCanceled: self.isCanceled,
                mateElapsedDistance: self.mateElapsedDistance ?? 0,
                mateElapsedTime: self.mateElapsedTime ?? 0
            )
        case .team:
            return TeamRunningResult(
                userNickname: "temp",
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                calorie: self.calorie,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: tempEmoji,
                isCanceled: self.isCanceled,
                mateElapsedDistance: self.mateElapsedDistance ?? 0,
                mateElapsedTime: self.mateElapsedTime ?? 0
            )
        }
    }
}

struct UserResultDTO: Codable {
    var records: [String: RunningResultDTO]
}
