//
//  NotificationTableViewCell.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 20, family: .regular)
        label.text = "🤝"
        label.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray6.cgColor
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    private lazy var notificationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 16, family: .bold)
        label.text = "메이트 요청"
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 13, family: .regular)
        label.text = "minji님의 메이트 요청이 도착했습니다!"
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI() {
        // TODO: ViewModel에서 받아온 데이터로 업데이트 
    }
}

// MARK: - Private Functions

private extension NotificationTableViewCell {
    func configureUI() {
        self.contentView.addSubview(self.iconLabel)
        self.iconLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        self.contentView.addSubview(self.notificationTypeLabel)
        self.notificationTypeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.left.equalTo(self.iconLabel.snp.right).offset(10)
        }
        
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.notificationTypeLabel.snp.bottom).offset(5)
            make.left.equalTo(self.iconLabel.snp.right).offset(10)
        }
    }
}
