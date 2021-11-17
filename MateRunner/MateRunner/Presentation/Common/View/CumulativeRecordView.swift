//
//  CumulativeRecordView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import UIKit

final class CumulativeRecordView: UIStackView {
    private(set) lazy var timeLabel = self.createValueLabel()
    private(set) lazy var distanceLabel = self.createValueLabel()
    private(set) lazy var calorieLabel = self.createValueLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension CumulativeRecordView {
    func configureUI() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        
        let timeSection = self.createSection(text: "시간", valueLabel: self.timeLabel)
        let distanceSection = self.createSection(text: "km", valueLabel: self.distanceLabel)
        let calorieSection = self.createSection(text: "kcal", valueLabel: self.calorieLabel)
        
        let leftSeparator = self.createSeparator()
        let rightSeparator = self.createSeparator()
        
        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.distribution = .equalSpacing
        innerStackView.alignment = .center
        
        innerStackView.addArrangedSubview(leftSeparator)
        innerStackView.addArrangedSubview(distanceSection)
        innerStackView.addArrangedSubview(rightSeparator)
        
        self.addArrangedSubview(timeSection)
        self.addArrangedSubview(innerStackView)
        self.addArrangedSubview(calorieSection)
    }
    
    func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .bold)
        return label
    }
    
    func createNameLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 14, family: .regular)
        label.textColor = .darkGray
        label.text = text
        return label
    }
    
    func createSection(text: String, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        let nameLabel = self.createNameLabel(text: text)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }
    
    func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .darkGray
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(25)
        }
        return separator
    }
}
