//
//  MateProfileHeaderView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import UIKit

import SnapKit

final class MateProfileHeaderView: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.addShadow(location: .bottom)
        return view
    }()
    
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 20, family: .medium)
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
    
    func updateUI(time: String, distance: String, calorie: String) {
        self.cumulativeRecordView.timeLabel.text = time
        self.cumulativeRecordView.distanceLabel.text = distance
        self.cumulativeRecordView.calorieLabel.text = calorie
    }
}

// MARK: - Private Functions

private extension MateProfileHeaderView {
    func configureUI() {
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(344)
        }
        
        self.shadowView.addSubview(self.mateProfileImageView)
        self.mateProfileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(156)
        }
        
        self.shadowView.addSubview(self.mateNickname)
        self.mateNickname.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mateProfileImageView).offset(10)
        }
        
        self.shadowView.addSubview(self.cumulativeRecordView)
        self.cumulativeRecordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mateNickname).offset(22)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.shadowView.snp.bottom).offset(44)
            make.width.equalTo(305)
            make.centerX.equalToSuperview()
        }
    }
}
    
