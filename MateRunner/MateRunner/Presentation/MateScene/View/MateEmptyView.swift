//
//  MateEmptyView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

import SnapKit

final class MateEmptyView: UIView {
    convenience init(title: String, topOffset: Int) {
        self.init(frame: .zero)
        self.configureUI(title: title, topOffset: topOffset)
    }
}

// MARK: - Private Functions

private extension MateEmptyView {
    func configureUI(title: String, topOffset: Int) {
        let titleLabel = UILabel()
        
        titleLabel.font = .notoSans(size: 14, family: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topOffset)
        }
    }
}
