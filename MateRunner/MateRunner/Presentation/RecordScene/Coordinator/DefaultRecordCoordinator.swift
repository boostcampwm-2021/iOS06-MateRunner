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
        self.navigationController.pushViewController(self.recordViewController, animated: true)
    }
}

extension DefaultRecordCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {

    }
}
