//
//  RunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

protocol RunningUseCase {
    var runningSetting: RunningSetting { get set }
    var runningData: BehaviorSubject<RunningData> { get set }
    var isCanceled: BehaviorSubject<Bool> { get set }
    var isFinished: BehaviorSubject<Bool> { get set }
    var shouldShowPopUp: BehaviorSubject<Bool> { get set }
    var progress: BehaviorSubject<Double> { get set }
    var cancelTimeLeft: PublishSubject<Int> { get set }
    var popUpTimeLeft: PublishSubject<Int> { get set }
    func executePedometer()
    func executeActivity()
    func executeTimer()
    func executeCancelTimer()
    func executePopUpTimer()
    func invalidateCancelTimer()
    func createRunningResult(isCanceled: Bool) -> RunningResult
}
