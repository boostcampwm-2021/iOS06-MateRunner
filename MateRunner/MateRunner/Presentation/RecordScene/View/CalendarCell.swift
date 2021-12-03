//
//  CalendarCell.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import UIKit

import SnapKit

final class CalendarCell: UICollectionViewCell {
    static let identifier = "calendarCell"
    
    private(set) lazy var markView: UIView = {
        let markView = UIView()
        markView.layer.cornerRadius = 13
        markView.snp.makeConstraints { make in
            make.width.height.equalTo(26)
        }
        return markView
    }()
    
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 10, family: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(with model: CalendarModel?) {
        if let model = model {
            self.contentView.isHidden = false
            self.dayLabel.text = model.day
            self.updateMarkView(hasRecord: model.hasRecord)
            self.updateBackground(isSelected: model.isSelected)
        } else {
            self.contentView.isHidden = true
        }
    }
    
    func updateBackground(isSelected: Bool) {
        self.contentView.backgroundColor = isSelected ? .systemGray5 : .systemBackground
    }
}

private extension CalendarCell {
    func configureUI() {
        self.contentView.layer.cornerRadius = 10
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        
        stackView.addArrangedSubview(self.markView)
        stackView.addArrangedSubview(self.dayLabel)
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func updateMarkView(hasRecord: Bool) {
        self.markView.subviews.first?.removeFromSuperview()
        
        if hasRecord {
            let checkImageView = UIImageView()
            checkImageView.image = UIImage(systemName: "checkmark")
            self.markView.addSubview(checkImageView)
            checkImageView.tintColor = .systemBackground
            checkImageView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
        
        self.markView.backgroundColor = hasRecord ? .mrPurple : .systemGray4
        
    }
}
