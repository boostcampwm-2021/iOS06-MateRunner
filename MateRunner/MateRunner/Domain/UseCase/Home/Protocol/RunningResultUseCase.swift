//
//  RunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/06.
//

import Foundation

import RxSwift

protocol RunningResultUseCase {
    var runningResult: RunningResult { get set }
    func saveRunningResult() -> Observable<Bool>
}
