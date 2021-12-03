//
//  RunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

protocol RunningUseCase {
    var points: [Point] { get set }
    var currentMETs: Double { get set }
    var runningSetting: RunningSetting { get set }
    var runningData: BehaviorSubject<RunningData> { get set }
    var isCanceled: BehaviorSubject<Bool> { get set }
    var isCanceledByMate: BehaviorSubject<Bool> { get set }
    var isFinished: BehaviorSubject<Bool> { get set }
    var shouldShowPopUp: BehaviorSubject<Bool> { get set }
    var myProgress: BehaviorSubject<Double> { get set }
    var mateProgress: BehaviorSubject<Double> { get set }
    var totalProgress: BehaviorSubject<Double> { get set }
    var cancelTimeLeft: PublishSubject<Int> { get set }
    var popUpTimeLeft: PublishSubject<Int> { get set }
    var selfImageURL: PublishSubject<String> { get set }
    var selfWeight: BehaviorSubject<Double> { get set }
    var mateImageURL: PublishSubject<String> { get set }
    func loadUserInfo()
    func loadMateInfo()
    func updateRunningStatus()
    func cancelRunningStatus()
    func executePedometer()
    func executeActivity()
    func executeTimer()
    func executeCancelTimer()
    func executePopUpTimer()
    func invalidateCancelTimer()
    func listenRunningSession()
    func createRunningResult(isCanceled: Bool) -> RunningResult
}
