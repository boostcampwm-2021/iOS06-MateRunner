//
//  DefaultTabBarCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

final class DefaultTabBarCoordinator: NSObject, TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(invitationDidReceive(_:)),
            name: NotificationCenterKey.invitationDidReceive,
            object: nil
        )
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = UIColor.mrPurple
        
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: UIImage(named: page.tabIconName()),
            tag: page.pageOrderNumber()
        )
    }
    
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .mate:
            let mateCoordinator = DefaultMateCoordinator(tabNavigationController)
            mateCoordinator.finishDelegate = self
            self.childCoordinators.append(mateCoordinator)
            mateCoordinator.start()
        case .record:
            let recordCoordinator = DefaultRecordCoordinator(tabNavigationController)
            recordCoordinator.finishDelegate = self
            self.childCoordinators.append(recordCoordinator)
            recordCoordinator.start()
        case .mypage:
            let myPageCoordinator = DefaultMyPageCoordinator(tabNavigationController)
            myPageCoordinator.finishDelegate = self
            self.childCoordinators.append(myPageCoordinator)
            myPageCoordinator.start()
        }
    }
}

extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        if childCoordinator.type == .home {
            navigationController.viewControllers.removeAll()
        }
    }
}

extension DefaultTabBarCoordinator: InvitationReceivable {
    func invitationDidAccept(with settingData: RunningSetting) {
        self.navigationController.dismiss(animated: true)
        self.selectPage(.home)
        let homeCooridnator = self.findCoordinator(type: .home) as? HomeCoordinator
        homeCooridnator?.startRunningFromInvitation(with: settingData)
    }
    
    func invitationDidReject() {
        self.navigationController.dismiss(animated: true)
    }
    
    @objc func invitationDidReceive(_ notification: Notification) {
        guard let invitation = notification.userInfo?[NotificationCenterKey.invitation] as? Invitation else { return }
        let invitationViewController = InvitationViewController()
        self.configureInvitationViewController(invitationViewController, invitation: invitation)
        
        self.tabBarController.present(invitationViewController, animated: true)
    }
    
    private func configureInvitationViewController(_ viewController: InvitationViewController, invitation: Invitation) {
        let useCase = DefaultInvitationUseCase(
            invitation: invitation,
            invitationRepository: DefaultInvitationRepository(
                realtimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
            )
        )
        let viewModel = InvitationViewModel(coordinator: self, invitationUseCase: useCase)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .overFullScreen
        viewController.hidesBottomBarWhenPushed = true
        viewController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        viewController.view.isOpaque = false
    }
}
