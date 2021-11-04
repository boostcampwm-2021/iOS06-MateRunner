//
//  RunningInfoView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

final class RunningInfoView: UIStackView {
    convenience init(name: String, value: String, isLarge: Bool = false) {
        self.init(frame: .zero)
        configureUI(name: name, value: value, isLarge: isLarge)
    }
}

// MARK: - Private Functions

private extension RunningInfoView {
    func configureUI(name: String, value: String, isLarge: Bool) {
        let nameLabel = UILabel()
        let valueLabel = UILabel()
        
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = name
        
        if isLarge {
            valueLabel.font = .notoSansBoldItalic(size: 100)
            self.spacing = -15
        } else {
            valueLabel.font = .notoSans(size: 30, family: .bold)
        }
        valueLabel.text = value
        
        self.axis = .vertical
        self.alignment = .center
        self.addArrangedSubview(valueLabel)
        self.addArrangedSubview(nameLabel)
    }
    
    func updateValue(newValue: String) {
        guard let valueLabel = self.subviews.first as? UILabel else { return }
        valueLabel.text = newValue
    }
}
