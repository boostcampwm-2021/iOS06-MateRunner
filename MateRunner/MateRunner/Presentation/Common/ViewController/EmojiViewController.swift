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
    var viewModel: EmojiViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.backgroundColor = .systemBackground
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
        
        self.viewModel?.emojiObservable
            .bind(
                to: self.collectionView.rx.items(
                    cellIdentifier: "default", cellType: UICollectionViewCell.self
                )
            ) { row, _, cell  in
                let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
                title.textAlignment = .center
                title.text = Emoji.allCases[row].text()
                cell.contentView.addSubview(title)
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let input = EmojiViewModel.Input(
            emojiCellTapEvent: self.collectionView.rx.itemSelected.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.$selectedEmoji
            .asDriver()
            .filter { $0 != nil }
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}
