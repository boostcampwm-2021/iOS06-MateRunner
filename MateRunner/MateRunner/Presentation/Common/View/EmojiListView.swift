//
//  EmojiListView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import UIKit

final class EmojiListView: UIScrollView {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func bindUI(emojiList: [String: String]) {
        emojiList.forEach { emoji, count in
            let emojiView = EmojiView(emoji: emoji, count: count)
            self.contentStackView.addArrangedSubview(emojiView)
        }
    }
}

private extension EmojiListView {
    func configureUI() {
        self.showsHorizontalScrollIndicator = false
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
