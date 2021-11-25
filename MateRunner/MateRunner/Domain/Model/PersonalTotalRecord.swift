//
//  PresonalTotalRecord.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

struct PersonalTotalRecord {
    let distance: Double
    let time: Int
    let calorie: Double
    
    func createCumulativeRecord(distance: Double, time: Int, calorie: Double) -> Self {
        return PersonalTotalRecord(
            distance: self.distance + distance,
            time: self.time + time,
            calorie: self.calorie + calorie
        )
    }
}
