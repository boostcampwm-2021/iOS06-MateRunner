//
//  RecordUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

import RxSwift

protocol RecordUseCase {
    var time: PublishSubject<Int> { get set }
    var distance: PublishSubject<Double> { get set }
    var calorie: PublishSubject<Double> { get set }
    var userInfo: PublishSubject<UserProfileDTO> {get set }
    var month: BehaviorSubject<Date?> { get set }
    var selectedDay: BehaviorSubject<Date?> { get set }
    var runningCount: PublishSubject<Int> { get set }
    var likeCount: PublishSubject<Int> { get set }
    var montlyRecords: BehaviorSubject<[RunningResult]> { get set }
    func loadCumulativeRecord()
    func refresh()
    func loadMonthlyRecord()
    func updateMonth(toNext: Bool)
    func fetchRecordList()
}
