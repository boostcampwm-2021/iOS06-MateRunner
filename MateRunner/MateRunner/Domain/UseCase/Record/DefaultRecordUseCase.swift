//
//  DefaultRecordUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

import RxSwift

final class DefaultRecordUseCase: RecordUseCase {
    var time = PublishSubject<Int>()
    var distance = PublishSubject<Double>()
    var calorie = PublishSubject<Double>()
    var date = PublishSubject<Date>()
    var runningCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    
    func loadCumulativeRecord() {
        self.time.onNext(1234)
        self.distance.onNext(42.19)
        self.calorie.onNext(89.16)
    }
    
    func loadMonthRecord() {
        self.runningCount.onNext(15)
        self.likeCount.onNext(120)
    }
}
