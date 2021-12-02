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
    private let disposeBag = DisposeBag()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var contentsStackView = self.createContentsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureSubviews()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

private extension TermsViewController {
    func configureNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "이용 약관"
    }
    
    func configureSubviews() {
        self.view.addSubview(self.contentsView)
        self.contentsView.addSubview(self.contentsStackView)
    }
    
    func configureUI() {
        self.view.backgroundColor = .mrYellow
        
        self.contentsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(560)
        }
        
        self.contentsStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().offset(-40)
        }
    }
    
    func createTextTitleLabel(of text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .label
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
            make.height.equalTo(140)
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
