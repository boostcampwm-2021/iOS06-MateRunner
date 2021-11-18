//
//  RunningRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/09.
//

import Foundation

import RxSwift

protocol RunningRepository {
    func listen(sessionId: String, mate: String) -> Observable<RunningRealTimeData>
    func save(_ domain: RunningRealTimeData, sessionId: String, user: String)
    func stopListen(sessionId: String, mate: String)
}
