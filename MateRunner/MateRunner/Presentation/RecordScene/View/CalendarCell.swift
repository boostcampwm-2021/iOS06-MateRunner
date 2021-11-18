//
//  CalendarCell.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
    static let identifier = "calendarCell"
    
    private(set) lazy var markView: UIImageView = {
        let markView = UIImageView()
        markView.backgroundColor = .systemGray5
        markView.layer.cornerRadius = 13
        markView.snp.makeConstraints { make in
            make.width.height.equalTo(26)
        }
        return markView
    }()
    
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 10, family: .regular)
        label.text = "11"
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
}

private extension CalendarCell {
    func configureUI() {
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
}
