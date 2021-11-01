//
//  HomeViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("달리기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}

// MARK: - Private Functions

private extension HomeViewController {
    @objc func startButtonDidTap() {
        let distanceSettingViewController = DistanceSettingViewController()
        self.navigationController?.pushViewController(distanceSettingViewController, animated: true)
    }
}
