//
//  RunningResultRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

protocol RunningResultRepository {
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Bool>
}
