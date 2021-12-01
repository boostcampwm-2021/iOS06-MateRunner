//
//  MockTimerService.swift
//  MateRunnerUseCaseTests
//
//  Created by 전여훈 on 2021/12/02.
//

import Foundation

import RxSwift

class MockTimerService: RxTimerService {
    var disposeBag: DisposeBag = DisposeBag()
    
    func start() -> Observable<Int> {
        return Observable.from([0, 1, 2, 3, 4])
    }
    
    func stop() {
        self.disposeBag = DisposeBag()
    }
    
}
