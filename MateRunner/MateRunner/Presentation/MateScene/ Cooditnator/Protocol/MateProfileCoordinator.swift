//
//  MateProfileCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import Foundation

protocol MateProfileCoordinator: EmojiCoordinator {
    func pushMateProfileViewController()
    func pushRecordDetailViewController(with runningResult: RunningResult)
    func presentEmojiModal(
        connectedTo usecase: ProfileUseCase,
        mate: String,
        runningID: String
    )
}
