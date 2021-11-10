//
//  MateHeaderView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import UIKit

final class MateHeaderView: UITableViewHeaderFooterView {
    static let identifier = "mateHeaderView"
    
    private lazy var headerTitleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 18, family: .medium)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: Self.identifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(value: Int) {
        self.headerTitleLable.text = "친구 (\(value)명)"
    }
}

private extension MateHeaderView {
    func configureUI() {
        addSubview(headerTitleLable)
        self.headerTitleLable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
