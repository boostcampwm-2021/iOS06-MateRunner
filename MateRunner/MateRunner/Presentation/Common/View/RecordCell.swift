//
//  RecordCell.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import UIKit

class RecordCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private(set) lazy var cardView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private(set) lazy var modeEmoji = self.createLabel(size: 30)
    private(set) lazy var dateLabel = self.createLabel(size: 14, family: .medium)
    private(set) lazy var modeLabel = self.createLabel(size: 18, family: .bold)
    private(set) lazy var distanceLabel = self.createLabel(size: 14, color: .darkGray)
    private(set) lazy var timeLabel = self.createLabel(size: 14, color: .darkGray)
    private(set) lazy var calorieLabel = self.createLabel(size: 14, color: .darkGray)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(record: RunningResult) {
        self.dateLabel.text = record.dateTime?.toDateString(format: "yyyy.MM.dd")
        self.distanceLabel.text = record.userElapsedDistance.kilometerString + " km"
        self.timeLabel.text = record.userElapsedTime.timeString
        self.calorieLabel.text = record.calorie.calorieString + " kcal"
        
        switch record.runningSetting.mode {
        case .single:
            self.modeEmoji.text = "🏃‍♂️"
            self.modeLabel.text = "혼자 달리기"
        case .race, .team:
            self.modeEmoji.text = "🏃‍♂️🏃‍♀️"
            self.modeLabel.text = "같이 달리기"
        default:
            break
        }
    }
}

private extension RecordCell {
    func configureUI() {
        self.selectionStyle = .none
        self.configureCardView()
        self.contentView.addSubview(self.cardView)
        self.cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(15)
        }
    }
    
    func createLabel(size: CGFloat, family: UIFont.Family = .regular, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: size, family: family)
        label.textColor = color
        return label
    }
    
    func createEmojiSection() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 35
        view.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
        
        view.addSubview(self.modeEmoji)
        self.modeEmoji.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        return view
    }
    
    func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .darkGray
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
        }
        return separator
    }
    
    func createRecordSection() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        let leftSeparator = self.createSeparator()
        let rightSeparator = self.createSeparator()
        
        stackView.addArrangedSubview(self.distanceLabel)
        stackView.addArrangedSubview(leftSeparator)
        stackView.addArrangedSubview(self.timeLabel)
        stackView.addArrangedSubview(rightSeparator)
        stackView.addArrangedSubview(self.calorieLabel)
        return stackView
    }
    
    func createVerticalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        let recordSection = self.createRecordSection()
        stackView.addArrangedSubview(self.dateLabel)
        stackView.addArrangedSubview(self.modeLabel)
        stackView.addArrangedSubview(recordSection)
        return stackView
    }
    
    func configureCardView() {
        let emojiSection = self.createEmojiSection()
        let verticalStack = self.createVerticalStack()
        
        self.cardView.addSubview(emojiSection)
        emojiSection.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        self.cardView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(emojiSection.snp.right).offset(15)
        }
    }
}
