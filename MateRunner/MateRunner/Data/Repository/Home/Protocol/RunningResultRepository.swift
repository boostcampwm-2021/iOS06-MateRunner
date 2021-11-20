//
//  RunningResultRepository.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

protocol RunningResultRepository {
    init(fireStoreService: FireStoreNetworkService)
    func saveRunningResult(_ runningResult: RunningResult?) -> Observable<Void>
    func fetchUserNickname() -> String?
}
