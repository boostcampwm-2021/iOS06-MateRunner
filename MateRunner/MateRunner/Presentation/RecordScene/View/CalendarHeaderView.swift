//
//  CalendarHeaderView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import UIKit

final class CalendarHeaderView: UIStackView {
    private(set) lazy var dateLabel = self.createValueLabel()
    private(set) lazy var runningCountLabel = self.createValueLabel()
    private(set) lazy var likeCountLabel = self.createValueLabel()
    private(set) lazy var previousButton = self.createButton(name: "chevron.left")
    private(set) lazy var nextButton = self.createButton(name: "chevron.right")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

private extension CalendarHeaderView {
    func configureUI() {
        self.axis = .horizontal
        self.distribution = .fill
        
        let leftSection = self.createLeftSection()
        let buttonSection = self.createButtonSection()
        
        self.addArrangedSubview(leftSection)
        self.addArrangedSubview(buttonSection)
    }
    
    func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 14, family: .bold)
        return label
    }
    
    func createButton(name: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: name), for: .normal)
        button.tintColor = .label
        button.contentMode = .scaleAspectFill
        button.snp.makeConstraints { make in
            make.width.equalTo(button.snp.height)
        }
        return button
    }
    
    func createCountSection(name: String, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        let imageView = UIImageView(image: UIImage(systemName: name))
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.height)
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }
    
    func createLeftSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        
        let runningCountSection = self.createCountSection(
            name: "checkmark.circle.fill",
            valueLabel: self.runningCountLabel
        )
        
        let lickCountSection = self.createCountSection(
            name: "heart.fill",
            valueLabel: self.likeCountLabel
        )
        
        stackView.addArrangedSubview(self.dateLabel)
        stackView.addArrangedSubview(runningCountSection)
        stackView.addArrangedSubview(lickCountSection)
        return stackView
    }
    
    func createButtonSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 4
        
        stackView.addArrangedSubview(self.previousButton)
        stackView.addArrangedSubview(self.nextButton)
        return stackView
    }
}
