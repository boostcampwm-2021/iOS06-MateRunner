//
//  EmojiView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import UIKit

final class EmojiView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(emoji: String, count: String) {
        self.init(frame: .zero)
        self.configureUI(emoji: emoji, count: count)
    }
}

private extension EmojiView {
    func configureUI(emoji: String, count: String) {
        let emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 20)
        emojiLabel.text = emoji
        
        let countLabel = UILabel()
        countLabel.font = .notoSansBoldItalic(size: 20)
        countLabel.text = count
        
        self.stackView.addArrangedSubview(emojiLabel)
        self.stackView.addArrangedSubview(countLabel)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 25
    }
}
