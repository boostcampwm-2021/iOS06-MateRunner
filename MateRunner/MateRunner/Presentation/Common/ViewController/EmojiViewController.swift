//
//  EmojiViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import UIKit

import RxCocoa
import RxSwift

final class EmojiViewController: UIViewController {
    private lazy var emojiButton: [UIButton] = self.createEmojiList()
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.addArrangedSubview(self.createHorizontalStackView(from: 0, to: 3))
        stackView.addArrangedSubview(self.createHorizontalStackView(from: 4, to: 7))
        stackView.addArrangedSubview(self.createHorizontalStackView(from: 8, to: 11))
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension EmojiViewController {
    func configureUI() {
        self.view.addSubview(self.emojiView)
        self.emojiView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(254)
        }
        
        self.emojiView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.width.equalTo(265)
            make.height.equalTo(190)
        }
    }
    
    func bindUI() {
//        self.button[0].rx
    }
    
    func createEmojiButton(emoji: Emoji) -> UIButton {
        let button = UIButton()
        button.setTitle(emoji.icon(), for: .normal)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        return button
    }
    
    func createEmojiList() -> [UIButton] {
        var buttonList: [UIButton] = []
        Emoji.allCases.forEach {
            buttonList.append(self.createEmojiButton(emoji: $0))
        }
        return buttonList
    }
    
    func createHorizontalStackView(from: Int, to: Int) -> UIStackView {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 35
        (from...to).forEach {stackview.addArrangedSubview(self.emojiButton[$0])}
        return stackview
    }
}
