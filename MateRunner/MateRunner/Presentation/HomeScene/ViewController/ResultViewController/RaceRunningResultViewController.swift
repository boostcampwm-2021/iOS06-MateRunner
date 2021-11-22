//
//  RaceRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class RaceRunningResultViewController: RunningResultViewController {
    private lazy var lowerSeparator = self.createSeparator()
    private lazy var raceResultView = RaceResultView()
    private lazy var emojiButton = self.createEmojiButton()
    private lazy var reactionView = self.createReactionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.lowerSeparator)
        self.contentView.addSubview(self.raceResultView)
        self.contentView.addSubview(self.reactionView)
        self.contentView.addSubview(self.mapView)
    }
    
    func configureUI() {
        self.configureLowerSeparator()
        self.configureRaceResultView()
        self.configureReactionView()
        self.configureMapView(with: self.reactionView)
    }
}

private extension RaceRunningResultViewController {
    func configureLowerSeparator() {
        self.contentView.addSubview(self.lowerSeparator)
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureRaceResultView() {
        self.contentView.addSubview(self.raceResultView)
        self.raceResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
        // binding 후 제거 필요
        self.raceResultView.updateUI(nickname: "Jungwon", mateResult: "4.00", isWinner: true)
        // self.raceResultView.updateUI(nickname: "Jungwon", mateResult: "24:50", isWinner: false)
    }
    
    func configureReactionView() {
        self.contentView.addSubview(self.reactionView)
        self.reactionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.raceResultView.snp.bottom).offset(20)
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
