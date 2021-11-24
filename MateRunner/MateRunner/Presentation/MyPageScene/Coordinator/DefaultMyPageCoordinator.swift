//
//  DefaultMyPageCoordinator.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import UIKit

final class DefaultMyPageCoordinator: MyPageCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var myPageViewController: MyPageViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .mypage
    
    func start() {
        self.myPageViewController.viewModel = MyPageViewModel(
            myPageCoordinator: self,
            myPageUseCase: DefaultMyPageUseCase()
        )
        self.navigationController.pushViewController(self.myPageViewController, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myPageViewController = MyPageViewController()
    }
}
