//
//  RunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

protocol RunningUseCase: LocationDidUpdateDelegate {
    var runningSetting: RunningSetting { get set }
    var runningData: BehaviorSubject<RunningData> { get set }
    var finishRunning: BehaviorSubject<Bool> { get set }
    var cancelTimeLeft: BehaviorSubject<Int> { get set }
    var inCancelled: BehaviorSubject<Bool> { get set }
    var popUpTimeLeft: BehaviorSubject<Int> { get set }
    var shouldShowPopUp: BehaviorSubject<Bool> { get set }
    var progress: BehaviorSubject<Double> { get set }
    func executePedometer()
    func executeActivity()
    func executeTimer()
    func executeCancelTimer()
    func executePopUpTimer()
    func invalidateCancelTimer()
    func createRunningResult(isCanceled: Bool) -> RunningResult
}
