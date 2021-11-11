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
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        return collectionView
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
        
        self.emojiView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(250)
            make.height.equalTo(180)
        }
        
    }
    
    func createEmojiButton(emoji: Emoji) -> UIButton {
        let button = UIButton()
        button.setTitle(emoji.icon(), for: .normal)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        return button
    }
}

// MARK: - UICollectionViewDelegate

extension EmojiViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath)
//    -> CGSize {
//        return CGSize(width: self.collectionView.frame.width/7, height: 50)
//    }
}

// MARK: - UICollectionViewDataSource

extension EmojiViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        cell.largeContentTitle = Emoji.allCases[indexPath.row].icon()
        cell.largeContentTitle = "!!!"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Emoji.allCases.count
    }
}
