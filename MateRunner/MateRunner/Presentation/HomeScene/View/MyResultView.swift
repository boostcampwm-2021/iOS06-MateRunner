//
//  MyResultView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class MyResultView: UIStackView {
    convenience init(distanceLabel: UILabel, calorieLabel: UILabel, timeLabel: UILabel) {
        self.init(frame: .zero)
        self.configureUI(distanceLabel: distanceLabel, calorieLabel: calorieLabel, timeLabel: timeLabel)
    }
}

private extension MyResultView {
    func configureUI(distanceLabel: UILabel, calorieLabel: UILabel, timeLabel: UILabel) {
        let calorieSection = self.createSectionView(valueLabel: calorieLabel, name: "칼로리")
        let timeSection = self.createSectionView(valueLabel: timeLabel, name: "시간")
        let distanceSection = self.createSectionView(valueLabel: distanceLabel, name: "킬로미터", isDistance: true)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 50
        
        horizontalStack.addArrangedSubview(calorieSection)
        horizontalStack.addArrangedSubview(timeSection)
        
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 15
        
        self.addArrangedSubview(distanceSection)
        self.addArrangedSubview(horizontalStack)
    }
    
    func createSectionView(valueLabel: UILabel, name: String, isDistance: Bool = false) -> UIStackView {
        let fontSize = isDistance ? 20.0 : 18.0
        let nameLabel = UILabel()
        nameLabel.textColor = .systemGray
        nameLabel.text = name
        nameLabel.font = .notoSans(size: fontSize, family: .light)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = isDistance ? .leading : .center
        
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }
}
