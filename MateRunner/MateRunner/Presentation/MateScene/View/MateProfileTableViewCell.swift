//
//  MateProfileTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

import SnapKit

final class MateProfilTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var mateNickname: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .bold)
        return label
    }()
    
    private lazy var cumulativeRecordView = CumulativeRecordView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(image: String, nickname: String, time: String, distance: String, calorie: String) {
        self.mateProfileImageView.setImage(with: image)
        self.mateNickname.text = nickname
        self.cumulativeRecordView.timeLabel.text = time
        self.cumulativeRecordView.distanceLabel.text = distance
        self.cumulativeRecordView.calorieLabel.text = calorie
    }
}

// MARK: - Private Functions

private extension MateProfilTableViewCell {
    func configureUI() {
        self.contentView.addSubview(self.mateProfileImageView)
        self.mateProfileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(80)
        }
        
        self.contentView.addSubview(self.mateNickname)
        self.mateNickname.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mateProfileImageView.snp.bottom).offset(10)
        }
        
        self.contentView.addSubview(self.cumulativeRecordView)
        self.cumulativeRecordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mateNickname).offset(70)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
    
