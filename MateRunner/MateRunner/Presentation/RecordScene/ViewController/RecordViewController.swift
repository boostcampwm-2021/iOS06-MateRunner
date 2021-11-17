//
//  RecordViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

final class RecordViewController: UIViewController {
    private lazy var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.label.text = "기록 화면"
        self.view.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
