//
//  MockRecordUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockRecordUseCase: RecordUseCase {
    var totalRecord = PublishSubject<PersonalTotalRecord>()
    var month = BehaviorSubject<Date?>(value: Date().startOfMonth)
    var selectedDay = BehaviorSubject<Date?>(value: Date())
    var runningCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    var monthlyRecords = BehaviorSubject<[RunningResult]>(value: [])
    
    func loadTotalRecord() {
        let mockTotalRecord = PersonalTotalRecord(
            distance: 12.34,
            time: 789,
            calorie: 234.56
        )
        self.totalRecord.onNext(mockTotalRecord)
    }
    
    func refreshRecords() {
        self.month.onNext(try? self.month.value())
    }
    
    func loadMonthlyRecord() {
        let mockMonthlyRecords = [
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-yujin-20211130105106",
                    mode: .race,
                    targetDistance: 5.00,
                    hostNickname: "yujin",
                    mateNickname: "Minji",
                    dateTime: Date().startOfMonth
                ), userNickname: "yujin"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-hunhun-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "hunhun",
                    mateNickname: "Jungwon",
                    dateTime: Date().startOfMonth
                ), userNickname: "hunhun"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-Minji-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "Minji",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ), userNickname: "Minji"
            )
        ]
        self.monthlyRecords.onNext(mockMonthlyRecords)
        self.runningCount.onNext(mockMonthlyRecords.count)
        self.likeCount.onNext(0)
    }
    
    func updateMonth(toNext: Bool) {
        guard let month = try? self.month.value() else { return }
        
        let updatedDate = toNext ? month.nextMonth?.startOfMonth : month.previousMonth?.startOfMonth
        self.selectedDay.onNext(updatedDate)
        self.month.onNext(updatedDate)
    }
}
