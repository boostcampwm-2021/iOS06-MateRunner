//
//  TabBarController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

class TabBarController: UITabBarController {
    private lazy var homeNavigationController: UINavigationController = {
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        homeNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: nil)
        return homeNavigationController
    }()

    private lazy var recordNavigationController: UINavigationController = {
        let recordNavigationController = UINavigationController(rootViewController: RecordViewController())
        recordNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "record"), selectedImage: nil)
        return recordNavigationController
    }()

    private lazy var mateNavigationController: UINavigationController = {
        let mateNavigationController = UINavigationController(rootViewController: MateViewController())
        mateNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "mate"), selectedImage: nil)
        return mateNavigationController
    }()

    private lazy var mypageNavigationController: UINavigationController = {
        let mypageNavigationController = UINavigationController(rootViewController: MyPageViewController())
        mypageNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "mypage"), selectedImage: nil)
        return mypageNavigationController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        let viewControllers = [
            homeNavigationController,
            recordNavigationController,
            mateNavigationController,
            mypageNavigationController
        ]

        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(red: 122.0 / 255.0, green: 126.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        setViewControllers(viewControllers, animated: false)
    }
}
