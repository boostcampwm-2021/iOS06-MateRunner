//
//  DefaultRecordDetailUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import Foundation

final class DefaultRecordDetailUseCase: RecordDetailUseCase {
    private let userRepository: UserRepository
    let runningResult: RunningResult
    let nickname: String?
    
    init(userRepository: UserRepository, with runningResult: RunningResult) {
        self.runningResult = runningResult
        self.userRepository = userRepository
        self.nickname = self.userRepository.fetchUserNickname()
    }
}
