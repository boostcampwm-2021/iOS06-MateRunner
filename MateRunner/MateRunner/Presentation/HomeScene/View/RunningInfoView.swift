//
//  RunningInfoView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

final class RunningInfoView: UIStackView {
	let nameLabel = UILabel()
	let valueLabel = UILabel()
	
    convenience init(name: String, value: String, isLarge: Bool = false) {
        self.init(frame: .zero)
		self.configureUI(name: name, value: value, isLarge: isLarge)
    }
}

// MARK: - Private Functions

private extension RunningInfoView {
    func configureUI(name: String, value: String, isLarge: Bool) {
		self.nameLabel.font = .notoSans(size: 16, family: .regular)
		self.nameLabel.textColor = .darkGray
		self.nameLabel.text = name
		self.valueLabel.font = .notoSans(size: 30, family: .bold)
        
		if isLarge {
			self.valueLabel.font = .notoSansBoldItalic(size: 100)
            self.spacing = -15
		}
		
		self.valueLabel.text = value
		
        self.axis = .vertical
        self.alignment = .center
		
		self.addArrangedSubview(self.valueLabel)
		self.addArrangedSubview(self.nameLabel)
    }
    
    func updateValue(newValue: String) {
		self.valueLabel.text = newValue
    }
}
