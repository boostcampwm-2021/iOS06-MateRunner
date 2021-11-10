//
//  DefaultTeamRunningUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultTeamRunningUseCase: TeamRunningUseCase {
    private let teamRunningRepository = DefaultTeamRunningRepository()
    var myDistance: BehaviorSubject<Double> = BehaviorSubject(value: 0)
    var mateRunningData: BehaviorSubject<RunningRealTimeData> = BehaviorSubject(
        value: RunningRealTimeData(
            elapsedDistance: 0,
            elapsedTime: 0
        )
    )
    var totalDistance: BehaviorSubject<Double> = BehaviorSubject(value: 0)
    private var disposeBag = DisposeBag()

    func execute() {
        // listen
        self.teamRunningRepository.listen(sessionId: "session00", mate: "honux")
            .bind(to: self.mateRunningData)
            .disposed(by: self.disposeBag)
        
        self.mateRunningData
            .map { data in
                var total: Double = 0
                do {
                    total = try self.myDistance.value() + data.elapsedDistance
                } catch {
                    return 0
                }
                return total
            }
            .catchAndReturn(0)
            .bind(to: totalDistance)
            .disposed(by: self.disposeBag)
        
        self.myDistance
            .map { myDistance in
                var total: Double = 0
                do {
                    total = try self.mateRunningData.value().elapsedDistance + myDistance
                } catch {
                    return 0
                }
                return total
            }
            .catchAndReturn(0)
            .bind(to: totalDistance)
            .disposed(by: self.disposeBag)
    
        // save
        self.generateTimer()
            .subscribe(onNext: { [weak self] newTime in
                self?.myDistance.onNext(Double(newTime))
                self?.teamRunningRepository.save(
                        RunningRealTimeData(
                            elapsedDistance: Double(newTime),
                            elapsedTime: newTime
                        ),
                        sessionId: "session00",
                        user: "jk"
                    )
            })
            .disposed(by: self.disposeBag)
    }
    
    private func generateTimer() -> Observable<Int> {
        return Observable<Int>
            .interval(
                RxTimeInterval.seconds(1),
                scheduler: MainScheduler.instance
            )
            .map { $0 + 1 }
    }
}
