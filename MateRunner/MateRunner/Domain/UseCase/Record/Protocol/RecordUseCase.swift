//
//  RecordUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

import RxSwift

protocol RecordUseCase {
    var totalRecord: PublishSubject<PersonalTotalRecord> {get set }
    var month: BehaviorSubject<Date?> { get set }
    var selectedDay: BehaviorSubject<Date?> { get set }
    var runningCount: PublishSubject<Int> { get set }
    var likeCount: PublishSubject<Int> { get set }
    var monthlyRecords: BehaviorSubject<[RunningResult]> { get set }
    func loadTotalRecord()
    func refreshRecords()
    func loadMonthlyRecord()
    func updateMonth(toNext: Bool)
}
