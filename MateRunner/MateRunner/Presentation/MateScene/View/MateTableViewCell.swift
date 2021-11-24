//
//  MateTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import UIKit

class MateTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    lazy var mateNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 16, family: .medium)
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
    
    func updateUI(name: String, image: String) {
        self.mateProfileImageView.setImage(with: image)
        self.mateNameLabel.text = name
    }
}

// MARK: - Private Functions

private extension MateTableViewCell {
    func configureUI() {
        contentView.addSubview(self.mateProfileImageView)
        self.mateProfileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(self.mateNameLabel)
        self.mateNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.mateProfileImageView.snp.right).offset(13)
        }
    }
}
