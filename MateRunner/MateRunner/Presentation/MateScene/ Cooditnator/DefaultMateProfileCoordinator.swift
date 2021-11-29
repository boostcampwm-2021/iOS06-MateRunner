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
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
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
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                ),
                with: runningResult
            )
        )
        recordDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(recordDetailViewController, animated: true)
    }
    
    func presentEmojiModal(
        connectedTo usecase: ProfileUseCase,
        mate: String,
        runningID: String
    ) {
        let emojiViewController = EmojiViewController()
        emojiViewController.viewModel = EmojiViewModel(
            coordinator: self, emojiUseCase: DefaultEmojiUseCase(
                firestoreRepository: DefaultFirestoreRepository(
                    urlSessionService: DefaultURLSessionNetworkService()
                ), mateRepository: DefaultMateRepository(
                    realtimeNetworkService: DefaultRealtimeDatabaseNetworkService(),
                    urlSessionNetworkService: DefaultURLSessionNetworkService()
                ), userRepository: DefaultUserRepository(
                    realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                ), delegate: usecase
            )
        )
        emojiViewController.viewModel?.emojiUseCase.runningID = runningID
        emojiViewController.viewModel?.emojiUseCase.mateNickname = mate
        self.navigationController.present(emojiViewController, animated: true)
    }
}
