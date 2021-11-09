//
//  MateTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import UIKit

class MateTableViewCell: UITableViewCell {
    static let identifier = "mateTableViewCell"
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private lazy var mateNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 16, family: .medium)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(self.mateProfileImageView)
        self.mateProfileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(self.mateNameLabel)
        self.mateNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.mateProfileImageView.snp.right).offset(13)
        }
    }
    
    func updateUI(image: String, name: String) {
        self.mateNameLabel.text = name
    }
}
