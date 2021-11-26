//
//  DefaultMateProfileCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

protocol EmojiCoordinator: Coordinator {
    
}

final class DefaultMateProfileCoordinator: MateProfileCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .addMate }
    var user: String?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.pushMateProfileViewController()
    }
    
    func pushMateProfileViewController() {
        let mateProfileViewController = MateProfileViewController()
        mateProfileViewController.viewModel = MateProfileViewModel(
            nickname: self.user ?? "",
            coordinator: self,
            profileUseCase: DefaultProfileUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                ),
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(mateProfileViewController, animated: true)
    }
    
    func pushRecordDetailViewController(with runningResult: RunningResult) {
        let recordDetailViewController = RecordDetailViewController()
        recordDetailViewController.viewModel = RecordDetailViewModel(
            recordDetailUseCase: DefaultRecordDetailUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                ),
                with: runningResult
            )
        )
        self.navigationController.pushViewController(recordDetailViewController, animated: true)
    }
    
    func presentEmojiModal(mate: String, runningID: String) {
        let emojiViewController = EmojiViewController()
        emojiViewController.viewModel = EmojiViewModel(
            coordinator: self, emojiUseCase: DefaultEmojiUseCase(
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                )
            )
        )
        emojiViewController.viewModel?.runningID = runningID
        emojiViewController.viewModel?.mateNickname = mate
        self.navigationController.present(emojiViewController, animated: true)
    }
}
