//
//  RunningResultDataService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/04.
//

 import Foundation

 import FirebaseFirestore
 import FirebaseFirestoreSwift

 enum RunningResultDataService {
    static func domain(from dto: RunningResultDTO) -> RunningResult {
        let runningSetting = RunningSetting(
            mode: dto.mode,
            targetDistance: dto.targetDistance,
            mateNickname: dto.mateNickname,
            dateTime: dto.dateTime
        )
        switch dto.mode {
        case .single:
            return RunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: dto.userElapsedDistance,
                userElapsedTime: dto.userElapsedTime,
                kcal: dto.kcal,
                points: dto.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: dto.emojis,
                isCanceled: dto.isCanceled
            )
        case .race:
            return RaceRunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: dto.userElapsedDistance,
                userElapsedTime: dto.userElapsedTime,
                kcal: dto.kcal,
                points: dto.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: dto.emojis,
                isCanceled: dto.isCanceled,
                mateElapsedDistance: dto.mateElapsedDistance ?? 0,
                mateElapsedTime: dto.mateElapsedTime ?? 0
            )
        case .team:
            return TeamRunningResult(
                runningSetting: runningSetting,
                userElapsedDistance: dto.userElapsedDistance,
                userElapsedTime: dto.userElapsedTime,
                kcal: dto.kcal,
                points: dto.points.map { Point(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: dto.emojis,
                isCanceled: dto.isCanceled,
                mateElapsedDistance: dto.mateElapsedDistance ?? 0,
                mateElapsedTime: dto.mateElapsedTime ?? 0
            )
        }
    }

    static func dto(from domain: RunningResult) -> RunningResultDTO {
        let runningSetting = domain.runningSetting

        if let raceRunningResult = domain as? RaceRunningResult {
            return RunningResultDTO(
                mode: runningSetting.mode ?? .single,
                targetDistance: runningSetting.targetDistance ?? 0,
                mateNickname: runningSetting.mateNickname,
                dateTime: runningSetting.dateTime ?? Date(),
                userElapsedDistance: raceRunningResult.userElapsedDistance,
                userElapsedTime: raceRunningResult.userElapsedTime,
                mateElapsedDistance: raceRunningResult.mateElapsedDistance,
                mateElapsedTime: raceRunningResult.mateElapsedTime,
                kcal: raceRunningResult.kcal,
                points: raceRunningResult.points.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: raceRunningResult.emojis,
                isCanceled: raceRunningResult.isCanceled
            )
        } else if let teamRunningResult = domain as? TeamRunningResult {
            return RunningResultDTO(
                mode: runningSetting.mode ?? .single,
                targetDistance: runningSetting.targetDistance ?? 0,
                mateNickname: runningSetting.mateNickname,
                dateTime: runningSetting.dateTime ?? Date(),
                userElapsedDistance: teamRunningResult.userElapsedDistance,
                userElapsedTime: teamRunningResult.userElapsedTime,
                mateElapsedDistance: teamRunningResult.mateElapsedDistance,
                mateElapsedTime: teamRunningResult.mateElapsedTime,
                kcal: teamRunningResult.kcal,
                points: teamRunningResult.points.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: teamRunningResult.emojis,
                isCanceled: teamRunningResult.isCanceled
            )
        } else {
            return RunningResultDTO(
                mode: runningSetting.mode ?? .single,
                targetDistance: runningSetting.targetDistance ?? 0,
                mateNickname: runningSetting.mateNickname,
                dateTime: runningSetting.dateTime ?? Date(),
                userElapsedDistance: domain.userElapsedDistance,
                userElapsedTime: domain.userElapsedTime,
                mateElapsedDistance: nil,
                mateElapsedTime: nil,
                kcal: domain.kcal,
                points: domain.points.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) },
                emojis: domain.emojis,
                isCanceled: domain.isCanceled
            )
        }
    }
 }
