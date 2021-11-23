//
//  RunningResultFirestoreDTO.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

struct RunningResultFirestoreDTO: Codable {
    private(set) var mode: StringValue
    private(set) var targetDistance: DoubleValue
    private(set) var mateNickname: StringValue?
    private(set) var dateTime: TimeStampValue
    private(set) var userElapsedDistance: DoubleValue
    private(set) var userElapsedTime: IntegerValue
    private(set) var mateElapsedDistance: DoubleValue?
    private(set) var mateElapsedTime: IntegerValue?
    private(set) var calorie: DoubleValue
    private(set) var points: ArrayValue<GeoPointValue>
    private(set) var emojis: MapValue?
    private(set) var isCanceled: BooleanValue
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case mode, targetDistance, mateNickname, dateTime, userElapsedDistance
        case userElapsedTime, mateElapsedDistance, mateElapsedTime, calorie
        case points, emojis, isCanceled
    }
    
    init? (runningResult: RunningResult) throws {
        guard let mode = runningResult.mode else {
            throw FirebaseServiceError.nilDataError
        }
        switch mode {
        case .single: try self.init(singleRunningResult: runningResult)
        case .race: try self.init(raceRunningResult: runningResult as? RaceRunningResult)
        case .team: try self.init(teamRunningResult: runningResult as? TeamRunningResult)
        }
    }
    
    private init? (singleRunningResult: RunningResult) throws {
        guard let mode = singleRunningResult.mode,
              let targetDistance = singleRunningResult.targetDistance,
              let dateTime = singleRunningResult.dateTime
        else {
            throw FirebaseServiceError.nilDataError
        }
        
        self.mode = StringValue(value: mode.rawValue)
        self.targetDistance = DoubleValue(value: targetDistance)
        self.dateTime = TimeStampValue(value: dateTime.yyyyMMddTHHmmssSSZ)
        self.userElapsedDistance = DoubleValue(value: singleRunningResult.userElapsedDistance)
        self.userElapsedTime = IntegerValue(value: String(singleRunningResult.userElapsedTime))
        self.calorie = DoubleValue(value: singleRunningResult.calorie)
        self.points = ArrayValue<GeoPointValue>(values: singleRunningResult.points.map({ GeoPointValue(value: $0) }))
        self.isCanceled = BooleanValue(value: singleRunningResult.isCanceled)
    }
    
    private init? (teamRunningResult: TeamRunningResult?) throws {
        guard let teamRunningResult = teamRunningResult else {
            throw FirebaseServiceError.typeMismatchError
        }
        guard let mateNickname = teamRunningResult.runningSetting.mateNickname else {
            throw FirebaseServiceError.nilDataError
        }
        
        try self.init(singleRunningResult: teamRunningResult)
        self.mateNickname = StringValue(value: mateNickname)
        self.mateElapsedDistance = DoubleValue(value: teamRunningResult.mateElapsedDistance)
        self.mateElapsedTime = IntegerValue(value: String(teamRunningResult.mateElapsedTime))
    }
    
    private init? (raceRunningResult: RaceRunningResult?) throws {
        guard let raceRunningResult = raceRunningResult else {
            throw FirebaseServiceError.typeMismatchError
        }
        guard let mateNickname = raceRunningResult.runningSetting.mateNickname else {
            throw FirebaseServiceError.nilDataError
        }
        try self.init(singleRunningResult: raceRunningResult)
        self.mateNickname = StringValue(value: mateNickname)
        self.mateElapsedDistance = DoubleValue(value: raceRunningResult.mateElapsedDistance)
        self.mateElapsedTime = IntegerValue(value: String(raceRunningResult.mateElapsedTime))
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        
        self.mode = try fieldContainer.decode(StringValue.self, forKey: .mode)
        self.mateNickname = try? fieldContainer.decode(StringValue.self, forKey: .mateNickname)
        
        self.targetDistance = try fieldContainer.decode(DoubleValue.self, forKey: .targetDistance)
        self.userElapsedDistance = try fieldContainer.decode(DoubleValue.self, forKey: .userElapsedDistance)
        self.mateElapsedDistance = try? fieldContainer.decode(DoubleValue.self, forKey: .mateElapsedDistance)
        
        self.dateTime = try fieldContainer.decode(TimeStampValue.self, forKey: .dateTime)
        self.userElapsedTime = try fieldContainer.decode(IntegerValue.self, forKey: .userElapsedTime)
        self.mateElapsedTime = try? fieldContainer.decode(IntegerValue.self, forKey: .mateElapsedTime)
        
        self.calorie = try fieldContainer.decode(DoubleValue.self, forKey: .calorie)
        self.isCanceled = try fieldContainer.decode(BooleanValue.self, forKey: .isCanceled)
        self.points = try fieldContainer.decode(ArrayValue<GeoPointValue>.self, forKey: .points)
        
        self.emojis = try? fieldContainer.decode(MapValue.self, forKey: .emojis)
    }
    
    func toDomain() throws -> RunningResult {
        guard let mode = RunningMode(rawValue: self.mode.value) else {
            throw FirebaseServiceError.nilDataError
        }
        
        let runningSetting = RunningSetting(
            mode: RunningMode(rawValue: self.mode.value),
            targetDistance: self.targetDistance.value,
            mateNickname: self.mateNickname?.value,
            dateTime: Date().convertToyyyyMMddTHHmmssSSZ(dateString: self.dateTime.value)
        )
        let runningData = RunningData(
            myRunningRealTimeData: RunningRealTimeData(
                elapsedDistance: self.userElapsedDistance.value,
                elapsedTime: Int(self.userElapsedTime.value) ?? 0
            ),
            mateRunningRealTimeData: RunningRealTimeData(
                elapsedDistance: (self.mateElapsedDistance?.value) ?? 0,
                elapsedTime: Int(self.mateElapsedTime?.value ?? "0") ?? 0
            ),
            calorie: self.calorie.value
        )
        
        return RunningResultFactory(
            runningSetting: runningSetting,
            runningData: runningData,
            points: self.points.arrayValue["values"]?.compactMap({ $0.value }) ?? [] ,
            isCanceled: self.isCanceled.value
        ).createResult(of: mode)
    }
}
