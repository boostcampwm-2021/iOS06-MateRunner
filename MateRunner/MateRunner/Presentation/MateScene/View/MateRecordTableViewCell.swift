//
//  MateRecordTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

final class MateRecordTableViewCell: RecordCell {
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .mrPurple
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureButton()
    }
}

// MARK: - Private Functions

private extension MateRecordTableViewCell {
    func configureButton() {
        self.cardView.addSubview(self.heartButton)
        self.heartButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(15)
        }
    }
}
