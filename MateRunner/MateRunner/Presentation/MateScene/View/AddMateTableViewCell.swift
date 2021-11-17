//
//  AddMateTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import UIKit

final class AddMateTableViewCell: MateTableViewCell {
    static var addIdentifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .mrPurple
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Functions

private extension AddMateTableViewCell {
    func configureUI() {
        contentView.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(38)
            make.right.equalToSuperview().offset(-22)
        }
    }
}
