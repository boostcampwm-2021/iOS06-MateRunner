//
//  DefaultAddMateCoordinator.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import UIKit

final class DefaultAddMateCoordinator: AddMateCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .addMate }
    
    func start() {
        self.pushAddMateViewController()
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushAddMateViewController() {
        let addMateViewController = AddMateViewController()
        addMateViewController.viewModel = AddMateViewModel(
            coordinator: self,
            mateUseCase: DefaultMateUseCase(
                repository: DefaultMateRepository(
                    networkService: DefaultFireStoreNetworkService()
                )
            )
        )
        self.navigationController.pushViewController(addMateViewController, animated: true)
    }
}
