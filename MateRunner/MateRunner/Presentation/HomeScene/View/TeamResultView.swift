//
//  TeamResultView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class TeamResultView: UIStackView {
    convenience init(totalDistanceLabel: UILabel, contributionLabel: UILabel) {
        self.init(frame: .zero)
        self.configureUI(totalDistanceLabel: totalDistanceLabel, contributionLabel: contributionLabel)
    }
}

// MARK: - Private Functions

private extension TeamResultView {
    func configureUI(totalDistanceLabel: UILabel, contributionLabel: UILabel) {
        let totalDistanceSection = self.createSectionView(
            valueLabel: totalDistanceLabel,
            unit: "킬로미터",
            name: "함께 달린 거리"
        )
        
        let contributionSection = self.createSectionView(
            valueLabel: contributionLabel,
            unit: "퍼센트",
            name: "나의 기여도"
        )
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 50
        
        horizontalStack.addArrangedSubview(totalDistanceSection)
        horizontalStack.addArrangedSubview(contributionSection)
        
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 24, family: .medium)
        titleLabel.text = "메이트와 달리기 완주!"
        
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 10
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(horizontalStack)
    }
    
    func createSectionView(valueLabel: UILabel, unit: String, name: String) -> UIStackView {
        let unitLabel = UILabel()
        unitLabel.font = .notoSans(size: 12, family: .light)
        unitLabel.textColor = .systemGray
        unitLabel.text = unit
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .lastBaseline
        horizontalStack.spacing = 4
        
        horizontalStack.addArrangedSubview(valueLabel)
        horizontalStack.addArrangedSubview(unitLabel)
        
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 18, family: .light)
        nameLabel.textColor = .systemGray
        nameLabel.text = name
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(nameLabel)
        
        return verticalStack
    }
}
