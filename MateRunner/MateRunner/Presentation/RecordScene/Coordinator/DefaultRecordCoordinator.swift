//
//  DefaultRecordCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import UIKit

final class DefaultRecordCoordinator: RecordCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var recordViewController: RecordViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .record
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.recordViewController = RecordViewController()
    }
    
    func start() {
        self.recordViewController.viewModel = RecordViewModel(
            coordinator: self,
            recordUsecase: DefaultRecordUseCase(
                userRepository: DefaultUserRepository(
                    networkService: DefaultFireStoreNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.recordViewController, animated: true)
    }
    
    func push(with runningResult: RunningResult) {
        let recordDetailViewController = RecordDetailViewController()
        recordDetailViewController.hidesBottomBarWhenPushed = true
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
}

extension DefaultRecordCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {

    }
}
