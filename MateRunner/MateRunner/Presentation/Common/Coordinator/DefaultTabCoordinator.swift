//
//  DefaultTabBarCoordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

class DefaultTabBarCoordinator: NSObject, TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .record, .mate, .mypage]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({
            createTabNavigationController(of: $0)
        })
        configureTabBarController(with: controllers)
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabViewControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController.view.backgroundColor = .systemBackground
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = UIColor.mrPurple
        
        self.navigationController.viewControllers = [tabBarController]
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: UIImage(named: page.tabIconName()),
            tag: page.pageOrderNumber()
        )
    }
    
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = configureTabBarItem(of: page)
        navigationController.pushViewController(self.createTabViewController(of: page), animated: true)
        
        return navigationController
    }
    
    private func createTabViewController(of page: TabBarPage) -> UIViewController {
        switch page {
        case .home: return HomeViewController()
        case .record: return HomeViewController()
        case .mate: return HomeViewController()
        case .mypage: return HomeViewController()
        }
    }
}
