//
//  RunningResultDTO.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/04.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct RunningResultDTO: Codable {
    private(set) var mode: RunningMode
    private(set) var targetDistance: Double
    private(set) var mateNickname: String?
    private(set) var dateTime: Date
    private(set) var userElapsedDistance: Double = 0
    private(set) var userElapsedTime: Int = 0
    private(set) var mateElapsedDistance: Double?
    private(set) var mateElapsedTime: Int?
    private(set) var kcal: Double = 0
    private(set) var points: [GeoPoint] = []
    private(set) var emojis: [String: Emoji] = [:]
    private(set) var isCanceled: Bool = false
    
    init(from domain: RunningResult) {
        let runningSetting = domain.runningSetting
        
        self.targetDistance = runningSetting.targetDistance ?? 0
        self.mateNickname = runningSetting.mateNickname
        self.dateTime = runningSetting.dateTime ?? Date()
        self.userElapsedDistance = domain.userElapsedDistance
        self.userElapsedTime = domain.userElapsedTime
        self.kcal = domain.kcal
        self.points = domain.points.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) }
        self.emojis = domain.emojis
        self.isCanceled = domain.isCanceled

        if let raceRunningResult = domain as? RaceRunningResult {
            self.mode = runningSetting.mode ?? .race
            self.mateElapsedDistance = raceRunningResult.mateElapsedDistance
            self.mateElapsedTime = raceRunningResult.mateElapsedTime
        } else if let teamRunningResult = domain as? TeamRunningResult {
            self.mode = runningSetting.mode ?? .team
            self.mateElapsedDistance = teamRunningResult.mateElapsedDistance
            self.mateElapsedTime = teamRunningResult.mateElapsedTime
        } else {
            self.mode = runningSetting.mode ?? .single
            self.mateElapsedDistance = nil
            self.mateElapsedTime = nil
        }
    }
}

extension RunningResultDTO {
    func toDomain() -> RunningResult {
        let runningSetting = RunningSetting(
            mode: self.mode,
            targetDistance: self.targetDistance,
            mateNickname: self.mateNickname,
            dateTime: self.dateTime
        )
        switch self.mode {
        case .single:
            return RunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                kcal: self.kcal,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: self.emojis,
                isCanceled: self.isCanceled
            )
        case .race:
            return RaceRunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                kcal: self.kcal,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: self.emojis,
                isCanceled: self.isCanceled,
                mateElapsedDistance: self.mateElapsedDistance ?? 0,
                mateElapsedTime: self.mateElapsedTime ?? 0
            )
        case .team:
            return TeamRunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: self.userElapsedDistance,
                userElapsedTime: self.userElapsedTime,
                kcal: self.kcal,
                points: self.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: self.emojis,
                isCanceled: self.isCanceled,
                mateElapsedDistance: self.mateElapsedDistance ?? 0,
                mateElapsedTime: self.mateElapsedTime ?? 0
            )
        }
    }
}

struct UserDTO: Codable {
    var nickname: String
    let records: [RunningResultDTO]
}
