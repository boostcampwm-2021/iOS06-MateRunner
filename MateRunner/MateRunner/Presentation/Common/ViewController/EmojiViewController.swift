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
    var viewModel: EmojiViewModel = EmojiViewModel()
    private var disposeBag = DisposeBag()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
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
    
    func bindViewModel() {
        let input = EmojiViewModel.Input(
            emojiCellTapEvent: self.collectionView.rx.itemSelected.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.$selectedEmoji
            .asDriver()
            .filter { $0 != nil }
            .drive(onNext: { [weak self] emoji in
                print(emoji?.icon())
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension EmojiViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        title.textAlignment = .center
        title.text = Emoji.allCases[indexPath.row].icon()
        cell.contentView.addSubview(title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Emoji.allCases.count
    }
}
