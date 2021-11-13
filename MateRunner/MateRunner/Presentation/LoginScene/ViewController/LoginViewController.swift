//
//  LoginViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import AuthenticationServices
import UIKit

final class LoginViewController: UIViewController {
    private lazy var titleStackView = self.createTitleStackView()
    private lazy var loginButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

private extension LoginViewController {
    func configureUI() {
        self.view?.backgroundColor = .mrYellow
        
        self.view.addSubview(self.titleStackView)
        self.titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        self.view.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(100)
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
