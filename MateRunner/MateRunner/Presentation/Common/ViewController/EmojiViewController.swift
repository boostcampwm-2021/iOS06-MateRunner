//
//  EmojiViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import UIKit

final class EmojiViewController: UIViewController {
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
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
    }
}
