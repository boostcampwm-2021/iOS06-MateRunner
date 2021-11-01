//
//  TabBarController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

final class TabBarController: UITabBarController {
    private lazy var homeNavigationController: UINavigationController = {
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "home"),
            selectedImage: nil
        )
        homeNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return homeNavigationController
    }()

    private lazy var recordNavigationController: UINavigationController = {
        let recordNavigationController = UINavigationController(rootViewController: RecordViewController())
        recordNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "record"),
            selectedImage: nil
        )
        recordNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return recordNavigationController
    }()

    private lazy var mateNavigationController: UINavigationController = {
        let mateNavigationController = UINavigationController(rootViewController: MateViewController())
        mateNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "mate"),
            selectedImage: nil
        )
        mateNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return mateNavigationController
    }()

    private lazy var myPageNavigationController: UINavigationController = {
        let myPageNavigationController = UINavigationController(rootViewController: MyPageViewController())
        myPageNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "mypage"),
            selectedImage: nil
        )
        myPageNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        return myPageNavigationController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension TabBarController {
    func configureUI() {
        let viewControllers = [
            self.homeNavigationController,
            self.recordNavigationController,
            self.mateNavigationController,
            self.myPageNavigationController
        ]

        self.view.backgroundColor = .systemBackground
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = UIColor.mrPurple
        self.setViewControllers(viewControllers, animated: false)
    }
}
