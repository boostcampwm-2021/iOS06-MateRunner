//
//  RaceResultView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class RaceResultView: UIStackView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .medium)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .black)
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 12, family: .light)
        label.textColor = .systemGray
        label.text = "킬로미터"
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .light)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateTitle(with text: String) {
        self.titleLabel.text = text
    }
    
    func updateMateDistance(with text: String) {
        self.valueLabel.text = text
    }
    
    func updateUI(nickname: String, mateResult: String, isWinner: Bool) {
        let raceResult = isWinner ? "승리" : "패배"
        self.titleLabel.text = "\(nickname)님의 \(raceResult)!"
        self.valueLabel.text = mateResult
        self.unitLabel.isHidden = !isWinner
        self.nameLabel.text = isWinner ? "메이트가 달린 거리" : "메이트가 완주한 시간"
    }
}

private extension RaceResultView {
    func configureUI() {
        let mateResultSection = self.createMateResultSection()
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 10

        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(mateResultSection)
    }
    
    func createMateResultSection() -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .lastBaseline
        horizontalStackView.spacing = 4
        
        horizontalStackView.addArrangedSubview(self.valueLabel)
        horizontalStackView.addArrangedSubview(self.unitLabel)
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(self.nameLabel)
        return verticalStackView
    }
}
