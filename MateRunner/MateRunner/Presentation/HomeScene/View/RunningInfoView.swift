//
//  RunningInfoView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

final class RunningInfoView: UIStackView {
    private let valueLabel = UILabel()
    
    convenience init(name: String, value: String, isLarge: Bool = false) {
        self.init(frame: .zero)
        configureUI(name: name, value: value, isLarge: isLarge)
    }
}

// MARK: - Private Functions

extension RunningInfoView {
    func configureUI(name: String, value: String, isLarge: Bool) {
        let nameLabel = UILabel()
        
        if isLarge {
            self.valueLabel.font = .notoSansBoldItalic(size: 100)
            self.spacing = -15
        } else {
            self.valueLabel.font = .notoSans(size: 30, family: .bold)
        }
        
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        self.valueLabel.text = value
        nameLabel.text = name
        
        self.axis = .vertical
        self.alignment = .center
        
        self.addArrangedSubview(valueLabel)
        self.addArrangedSubview(nameLabel)
    }
    
    func updateValue(newValue: String) {
        self.valueLabel.text = newValue
    }
}
