//
//  DefaultRxTimerService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/16.
//

import Foundation

import RxSwift

final class DefaultRxTimerService: RxTimerService {
    var disposeBag = DisposeBag()
    
    func start() -> Observable<Int> {
        return Observable<Int>
            .interval(
                RxTimeInterval.seconds(1),
                scheduler: MainScheduler.instance
            )
            .map { $0 + 1 }
    }
    
    func stop() {
        self.disposeBag = DisposeBag()
    }
}
