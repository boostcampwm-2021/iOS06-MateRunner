//
//  DistanceSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/01.
//

import SnapKit
import UIKit

final class DistanceSettingViewController: UIViewController {
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 80, family: .black)
        label.text = "5.00"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.distanceLabel)
        self.distanceLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}
