//
//  RoundedButton.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/02.
//

import UIKit

import SnapKit

final class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.configureUI(title: title)
    }
}

// MARK: - Private Functions

private extension RoundedButton {
    func configureUI(title: String = "") {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .notoSans(size: 16, family: .bold)
        self.layer.cornerRadius = 10
        self.backgroundColor = .mrPurple
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
