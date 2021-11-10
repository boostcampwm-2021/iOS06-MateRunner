//
//  InvitationViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

final class InvitationViewController: UIViewController {
    private lazy var invitationView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
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
        label.font = .notoSans(size: 20, family: .bold)
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
    
//    private lazy var stackView: UIStackView = {
//        let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.addArrangedSubview(self.distanceLabel)
//        stackview.addArrangedSubview(self.kilometerLabel)
//        return stackview
//    }()
    
    private lazy var descriptionModeLabel = self.createDescriptionLabel(text: "함께할 달리기")
    private lazy var descriptionDistanceLabel = self.createDescriptionLabel(text: "목표거리")
    private lazy var refuseButton = self.createInviteButton(text: "거절", color: .mrGray)
    private lazy var acceptButton = self.createInviteButton(text: "수락", color: .mrPurple)
    
    init(mate: String, mode: RunningMode, distance: Double) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = "🏃‍♂️🏃‍♀️\n메이트 \(mate)님의\n초대가 도착했습니다!"
        self.runningModeLabel.text = "🤜 \(mode.title)"
        self.distanceLabel.text = "\(distance)"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
}

// MARK: - Private Functions

private extension InvitationViewController {
    func configureUI() {
        self.view.backgroundColor = .gray
        
        self.view.addSubview(self.invitationView)
        self.invitationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(490)
        }
        
        self.invitationView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        self.invitationView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(238)
            make.height.equalTo(1)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25)
        }
        
        self.invitationView.addSubview(self.descriptionModeLabel)
        self.descriptionModeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.lineView).offset(18)
            make.centerX.equalToSuperview()
        }
        
        self.invitationView.addSubview(self.runningModeLabel)
        self.runningModeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.descriptionModeLabel.snp.bottom).offset(20)
        }
        
        self.invitationView.addSubview(self.descriptionDistanceLabel)
        self.descriptionDistanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.runningModeLabel.snp.bottom).offset(40)
        }
        
        self.invitationView.addSubview(self.distanceLabel)
        self.distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionDistanceLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(80)
        }
        
        self.invitationView.addSubview(self.kilometerLabel)
        self.kilometerLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-80)
            make.bottom.equalTo(self.distanceLabel.snp.bottom).offset(-10)
        }
        
//        self.invitationView.addSubview(self.stackView)
//        self.stackView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.descriptionDistanceLabel.snp.bottom).offset(20)
//        }
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
