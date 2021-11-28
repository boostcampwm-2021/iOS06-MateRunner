//
//  MateRecordTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import UIKit

import RxCocoa
import RxSwift

protocol HeartButtonDidTapDelegate: AnyObject {
    func heartButtonDidTap(_ sender: MateRecordTableViewCell, isCanceled: Bool)
}

final class MateRecordTableViewCell: RecordCell {
    private let disposeBag = DisposeBag()
    weak var delegate: HeartButtonDidTapDelegate?
    var indexPathRow = 0

    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .mrPurple
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func updateUI(record: RunningResult) {
        super.updateUI(record: record)
    }
    
    func updateHeartButton(nickname: String, sender: [String]) {
        if sender.contains(nickname) {
            self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}

// MARK: - Private Functions

private extension MateRecordTableViewCell {
    func configureButton() {
        self.cardView.addSubview(self.heartButton)
        self.heartButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(15)
        }
        self.bindUI()
    }
    
    func bindUI() {
        self.heartButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.heartButton.imageView?.image == UIImage(systemName: "heart") {
                    self.delegate?.heartButtonDidTap(self, isCanceled: false)
                } else {
                    self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.delegate?.heartButtonDidTap(self, isCanceled: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
