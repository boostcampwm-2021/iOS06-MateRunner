//
//  MateHeaderView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import UIKit

class MateHeaderView: UITableViewHeaderFooterView {
    static let identifier = "mateHeaderView"
    
    private lazy var headerTitleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 18, family: .medium)
        return label
    }()
    
    private func configureUI() {
        addSubview(headerTitleLable)
        self.headerTitleLable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateUI(value: Int) {
        self.headerTitleLable.text = "친구 (\(value)명)"
    }
}
