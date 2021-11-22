//
//  DefaultMateCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/15.
//

import UIKit

final class DefaultMateCoordinator: MateCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var mateViewController: MateViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .mate
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mateViewController = MateViewController()
    }
    
    func start() {
        self.mateViewController.mateViewModel = MateViewModel(
            coordinator: self,
            mateUseCase: DefaultMateUseCase(
                repository: DefaultMateRepository(
                    networkService: DefaultFireStoreNetworkService(),
                    realtimeNetworkService: DefaultRealtimeDatabaseNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(self.mateViewController, animated: true)
    }
    
    func showAddMateFlow() {
        let addMateCoordinator = DefaultAddMateCoordinator(self.navigationController)
        addMateCoordinator.finishDelegate = self
        self.childCoordinators.append(addMateCoordinator)
        addMateCoordinator.start()
    }
    
    func showMateProfileFlow() {
        let mateProfileCoordinator = DefaultMateProfileCoordinator(self.navigationController)
        mateProfileCoordinator.finishDelegate = self
        self.childCoordinators.append(mateProfileCoordinator)
        mateProfileCoordinator.start()
    }
}

extension DefaultMateCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter { $0.type != childCoordinator.type }
    }
}
