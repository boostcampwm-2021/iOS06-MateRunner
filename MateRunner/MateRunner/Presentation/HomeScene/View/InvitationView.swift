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
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 50)
        label.addShadow(offset: CGSize(width: 2.0, height: 2.0))
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
        stackview.addArrangedSubview(self.refuseButton)
        stackview.addArrangedSubview(self.acceptButton)
        return stackview
    }()
    
    private lazy var descriptionModeLabel = self.createDescriptionLabel(text: "함께할 달리기")
    private lazy var descriptionDistanceLabel = self.createDescriptionLabel(text: "목표거리")
    private lazy var refuseButton = self.createInviteButton(text: "거절", color: .mrGray)
    private lazy var acceptButton = self.createInviteButton(text: "수락", color: .mrPurple)
    
    convenience init(mate: String, mode: RunningMode, distance: Double) {
        self.init(frame: .zero)
        self.configureUI(mate: mate, mode: mode, distance: distance)
        
    }
}

// MARK: - Private Functions

private extension InvitationView {
    func configureUI(mate: String, mode: RunningMode, distance: Double) {
        self.updateValue(mate: mate, mode: mode, distance: distance)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        
        self.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(490)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(238)
            make.height.equalTo(1)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
        }
        
        self.addSubview(self.descriptionModeLabel)
        self.descriptionModeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lineView).offset(18)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(self.runningModeLabel)
        self.runningModeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionModeLabel.snp.bottom).offset(20)
        }
        
        self.addSubview(self.descriptionDistanceLabel)
        self.descriptionDistanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.runningModeLabel.snp.bottom).offset(40)
        }
        
        self.addSubview(self.distanceLabel)
        self.distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionDistanceLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(75)
        }
        
        self.addSubview(self.kilometerLabel)
        self.kilometerLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-75)
            make.bottom.equalTo(self.distanceLabel.snp.bottom).offset(-10)
        }
        
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
        }
        
        self.acceptButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        self.refuseButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func updateValue(mate: String, mode: RunningMode, distance: Double) {
        self.titleLabel.text = "🏃‍♂️🏃‍♀️\n메이트 \(mate)님의\n초대가 도착했습니다!"
        self.runningModeLabel.text = "🤜 \(mode.title)"
        self.distanceLabel.text = "\(String(format: "%.2f", distance))"
    }
    
    func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 16, family: .bold)
        label.text = text
        label.textAlignment = .center
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
