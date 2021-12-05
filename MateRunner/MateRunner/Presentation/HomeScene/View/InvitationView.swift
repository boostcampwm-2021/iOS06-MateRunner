//
//  InvitationView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

final class InvitationView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .notoSans(size: 18, family: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .mrGray
        return line
    }()
    
    private lazy var runningModeLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 23, family: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 50)
        label.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        label.textColor = .black
        return label
    }()
    
    private lazy var kilometerLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .light)
        label.text = "킬로미터"
        label.textColor = .gray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 20
        stackview.addArrangedSubview(self.rejectButton)
        stackview.addArrangedSubview(self.acceptButton)
        return stackview
    }()
    
    private lazy var descriptionModeLabel = self.createDescriptionLabel(text: "함께할 달리기")
    private lazy var descriptionDistanceLabel = self.createDescriptionLabel(text: "목표거리")
    lazy var rejectButton = self.createInviteButton(text: "거절", color: .mrGray)
    lazy var acceptButton = self.createInviteButton(text: "수락", color: .mrPurple)

    func updateTitleLabel(with mateNickname: String) {
        self.titleLabel.text = "🏃‍♂️🏃‍♀️\n메이트 \(mateNickname)님의\n초대가 도착했습니다!"
    }
    
    func updateDistanceLabel(with distance: String) {
        self.distanceLabel.text = distance
    }
    
    func updateModeLabel(with mode: String) {
        self.runningModeLabel.text = mode
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubViews()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSubViews()
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension InvitationView {
    func configureSubViews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.descriptionModeLabel)
        self.addSubview(self.runningModeLabel)
        self.addSubview(self.descriptionDistanceLabel)
        self.addSubview(self.distanceLabel)
        self.addSubview(self.kilometerLabel)
        self.addSubview(self.stackView)
    }
    
    func configureUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        
        self.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(490)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        self.lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(238)
            make.height.equalTo(1)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
        }
        
        self.descriptionModeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lineView).offset(18)
            make.centerX.equalToSuperview()
        }
    
        self.runningModeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionModeLabel.snp.bottom).offset(20)
        }
        
        self.descriptionDistanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.runningModeLabel.snp.bottom).offset(40)
        }
        
        self.distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionDistanceLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(75)
        }
        
        self.kilometerLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-75)
            make.bottom.equalTo(self.distanceLabel.snp.bottom).offset(-10)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
        }
        
        self.acceptButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        self.rejectButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 16, family: .bold)
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
    
    func createInviteButton(text: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSans(size: 18, family: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }
}
