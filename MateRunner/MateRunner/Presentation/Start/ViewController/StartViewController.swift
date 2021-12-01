//
//  StartViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/12/01.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class StartViewController: UIViewController {
    var viewModel: StartViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var titleStackView = self.createTitleStackView()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSans(size: 14, family: .bold)
        button.backgroundColor = .mrPurple
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.mrPurple, for: .normal)
        button.titleLabel?.font = .notoSans(size: 14, family: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.mrPurple.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
        self.bindViewModel()
    }
}

private extension StartViewController {
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        let input = StartViewModel.Input(
            signUpButtonDidTapEvent: self.signUpButton.rx.tap.asObservable(),
            loginEditButtonDidTapEvent: self.loginButton.rx.tap.asObservable())
        
        viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
    
    func configureSubviews() {
        self.view.addSubview(self.titleStackView)
        self.view.addSubview(self.signUpButton)
        self.view.addSubview(self.loginButton)
    }
    
    func configureUI() {
        self.view.backgroundColor = .mrYellow
        
        self.titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        self.signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.bottom.equalTo(self.titleStackView.snp.bottom).offset(200)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.top.equalTo(self.signUpButton.snp.bottom).offset(15)
        }
    }
    
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .racingSansOne(size: 80)
        label.text = text
        label.textColor = .mrPurple
        return label
    }
    
    func createTitleStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = -10
        
        stackView.addArrangedSubview(self.createTitleLabel(text: "Mate"))
        stackView.addArrangedSubview(self.createTitleLabel(text: "Runner"))
        return stackView
    }
}
