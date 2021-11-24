//
//  AddMateTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import UIKit

import RxCocoa
import RxSwift

protocol AddMateDelegate: AnyObject {
    func addMate(nickname: String)
}

final class AddMateTableViewCell: MateTableViewCell {
    static var addIdentifier: String {
        return String(describing: Self.self)
    }
    weak var delegate: AddMateDelegate?
    private let disposeBag = DisposeBag()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "person-add"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 18
        button.backgroundColor = .mrPurple
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        self.bindUI()
    }
}

// MARK: - Private Functions

private extension AddMateTableViewCell {
    func configureUI() {
        self.contentView.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(38)
            make.right.equalToSuperview().offset(-22)
        }
    }
    
    func bindUI() {
        self.addButton.rx.tap
            .bind { [weak self] in
                guard let mate = self?.mateNameLabel.text else { return }
                self?.addButton.isEnabled = false
                self?.addButton.backgroundColor = .mrGray
                self?.delegate?.addMate(nickname: mate)
            }
            .disposed(by: self.disposeBag)
    }
}
