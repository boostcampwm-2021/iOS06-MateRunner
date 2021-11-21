//
//  RaceResultView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class RaceResultView: UIStackView {
    private lazy var winnerLabel: UILabel = {
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
    
    private lazy var resultDescriptionLabel: UILabel = {
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
        self.winnerLabel.text = text
    }
    
    func updateMateResult(with text: String) {
        self.valueLabel.text = text
    }
    
    func updateMateResultDescription(with text: String) {
        self.resultDescriptionLabel.text = text
    }
    
    func toggleUnitLabel(shouldDisplay: Bool) {
        self.unitLabel.isHidden = !shouldDisplay
    }
}

private extension RaceResultView {
    func configureUI() {
        let mateResultSection = self.createMateResultSection()
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 10

        self.addArrangedSubview(self.winnerLabel)
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
        verticalStackView.addArrangedSubview(self.resultDescriptionLabel)
        return verticalStackView
    }
}
