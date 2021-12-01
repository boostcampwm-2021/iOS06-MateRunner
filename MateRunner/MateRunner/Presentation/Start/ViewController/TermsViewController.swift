//
//  TermsViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class TermsViewController: UIViewController {
    var viewModel: TermsViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관 동의"
        label.font = .notoSans(size: 24, family: .bold)
        label.textColor = .mrPurple
        return label
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var contentsStackView = self.createContentsStackView()
    
    private lazy var agreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 동의하고 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSans(size: 14, family: .bold)
        button.backgroundColor = .mrPurple
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var disagreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("동의하지 않음", for: .normal)
        button.setTitleColor(.mrPurple, for: .normal)
        button.titleLabel?.font = .notoSans(size: 14, family: .bold)
        button.backgroundColor = .none
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.mrPurple.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
        self.bindViewModel()
    }
}

private extension TermsViewController {
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        let input = TermsViewModel.Input(
            agreeButtonDidTapEvent: self.agreeButton.rx.tap.asObservable(),
            disagreeButtonDidTapEvent: self.disagreeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.isDisagreed
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureSubviews() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.contentsView)
        self.contentsView.addSubview(self.contentsStackView)
        self.view.addSubview(self.agreeButton)
        self.view.addSubview(self.disagreeButton)
    }
    
    func configureUI() {
        self.view.backgroundColor = .mrYellow
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.contentsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.height.equalToSuperview().offset(-300)
            make.width.equalToSuperview().offset(-50)
        }
        
        self.contentsStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().offset(-40)
        }
        
        self.agreeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(40)
            make.bottom.equalTo(self.contentsView.snp.bottom).offset(70)
        }
        
        self.disagreeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(40)
            make.top.equalTo(self.agreeButton.snp.bottom).offset(15)
        }
    }
    
    func createTextTitleLabel(of text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .notoSans(size: 14, family: .bold)
        return label
    }
    
    func createTextView(of path: String) -> UITextView {
        let textView = UITextView()
        textView.text = try? String(contentsOfFile: path)
        textView.font = .systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isSelectable = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.layer.borderColor = UIColor.mrPurple.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        return textView
    }
    
    func createTextStackView(of path: String, title: String) -> UIStackView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalCentering
            stackView.spacing = 5
            return stackView
        }()
        let textTitleLabel = self.createTextTitleLabel(of: title)
        let textView = self.createTextView(of: path)
        textView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(120)
        }
        stackView.addArrangedSubview(textTitleLabel)
        stackView.addArrangedSubview(textView)
        
        return stackView
    }
    
    func createContentsStackView() -> UIStackView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalCentering
            stackView.spacing = 10
            return stackView
        }()
        let serviceTextStackView = self.createTextStackView(
            of: FilePath.termsOfService,
            title: "서비스 이용약관"
        )
        let privacyTextStackView = self.createTextStackView(
            of: FilePath.termsOfPrivacy,
            title: "개인정보 수집 및 목적"
        )
        let locationTextStackView = self.createTextStackView(
            of: FilePath.termsOfLocationService,
            title: "위치기반 서비스 이용약관"
        )
        stackView.addArrangedSubview(serviceTextStackView)
        stackView.addArrangedSubview(privacyTextStackView)
        stackView.addArrangedSubview(locationTextStackView)
        
        return stackView
    }
    
    func showAlert() {
        let message = "서비스 이용약관, 개인정보 수집, 위치기반 서비스 이용약관에 모두 동의하지 않으면 Mate Runner앱을 이용할 수 없습니다."
        
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
}
