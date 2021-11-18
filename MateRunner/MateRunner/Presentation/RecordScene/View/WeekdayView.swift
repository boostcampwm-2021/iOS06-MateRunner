//
//  WeekdayView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import UIKit

final class WeekdayView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

private extension WeekdayView {
    func configureUI() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        
        let week = ["월", "화", "수", "목", "금", "토", "일"]
        week.forEach { [weak self] weekday in
            let label = UILabel()
            label.font = .notoSans(size: 10, family: .regular)
            label.textColor = .darkGray
            label.text = weekday
            label.textAlignment = .center
            self?.addArrangedSubview(label)
        }
    }
}
