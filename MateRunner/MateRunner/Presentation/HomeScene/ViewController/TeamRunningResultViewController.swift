//
//  TeamRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class TeamRunningResultViewController: RunningResultViewController {
    private lazy var lowerSeparator = self.createSeparator()
    private lazy var totalDistanceLabel = self.createValueLabel()
    private lazy var contributionLabel = self.createValueLabel()
    private lazy var emojiButton = self.createEmojiButton()
    private lazy var reactionView = self.createReactionView()

    private lazy var teamResultView = TeamResultView(
        totalDistanceLabel: self.totalDistanceLabel,
        contributionLabel: self.contributionLabel
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureDifferentSection() {
        self.configureLowerSeparator()
        self.configureTeamResultView()
        
        self.contentView.addSubview(self.emojiButton)
        self.configureReactionView()
        self.configureMapView()
    }
    
    override func configureMapView() {
        self.contentView.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.top.equalTo(self.reactionView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}

// MARK: - Private Functions

private extension TeamRunningResultViewController {
    func configureLowerSeparator() {
        self.contentView.addSubview(self.lowerSeparator)
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureTeamResultView() {
        self.contentView.addSubview(self.teamResultView)
        self.teamResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
    
    func configureReactionView() {
        self.contentView.addSubview(self.reactionView)
        self.reactionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.teamResultView.snp.bottom).offset(20)
        }
    }
    
    func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .black)
        return label
    }
    
    func createEmojiButton() -> UIButton {
        let button = UIButton()
        button.setTitle("→", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        return button
    }
    
    func createReactionView() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 24, family: .medium)
        titleLabel.text = "메이트를 칭찬해주세요!"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 15
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(self.emojiButton)
        
        return stackView
    }
}
