//
//  LoginViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import AuthenticationServices
import CryptoKit
import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: UIViewController {
    fileprivate var currentNonce: String?
    private let disposeBag = DisposeBag()
    var viewModel: LoginViewModel?
    
    private lazy var titleStackView = self.createTitleStackView()
    private lazy var loginButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var agreeView = UIView()
    
    private lazy var agreeButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.tintColor = .mrPurple
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mrPurple.cgColor
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private lazy var agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 이용약관 전체 동의(필수)"
        label.font = .notoSans(size: 15, family: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var termsView = UIView()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 약관 전문 보기"
        label.font = .notoSans(size: 14, family: .regular)
        return label
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.contentHorizontalAlignment = .right
        button.tintColor = .mrPurple
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.configureUI()
        self.bindUI()
        self.bindViewModel()
    }
}

private extension LoginViewController {
    func bindViewModel() {
        let input = LoginViewModel.Input(
            agreeButtonDidTapEvent: self.agreeButton.rx.tap.asObservable(),
            termsButtonDidTapEvent: self.termsButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.isAgreed
            .asDriver(onErrorJustReturn: false)
            .drive(self.loginButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        output?.isAgreed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isAgreed in
                if isAgreed {
                    self?.agreeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    self?.loginButton.alpha = 1.0
                } else {
                    self?.agreeButton.setImage(nil, for: .normal)
                    self?.loginButton.alpha = 0.5
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureSubViews() {
        self.view.addSubview(self.titleStackView)
        self.view.addSubview(self.contentsView)
        self.contentsView.addSubview(self.agreeView)
        self.agreeView.addSubview(self.agreeButton)
        self.agreeView.addSubview(self.agreeLabel)
        self.contentsView.addSubview(self.termsView)
        self.termsView.addSubview(self.termsLabel)
        self.termsView.addSubview(self.termsButton)
        self.view.addSubview(self.loginButton)
    }
    
    func configureUI() {
        self.view.backgroundColor = .mrYellow
        self.loginButton.isEnabled = false
        self.loginButton.alpha = 0.5
        
        self.titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        self.contentsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleStackView.snp.bottom).offset(90)
            make.width.equalTo(260)
            make.height.equalTo(100)
        }
        
        self.agreeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.width.equalTo(205)
            make.height.equalTo(25)
        }
        
        self.agreeButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        self.agreeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalTo(self.agreeButton)
            make.right.equalToSuperview()
        }
        
        self.termsView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(15)
            make.centerX.equalTo(self.agreeView)
            make.width.equalTo(205)
            make.height.equalTo(25)
        }
        
        self.termsLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.agreeLabel)
        }
        
        self.termsButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(self.termsLabel)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(40)
            make.top.equalTo(self.termsView.snp.bottom).offset(40)
        }
    }
    
    func bindUI() {
        self.loginButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.loginButtonDidTap()
            })
            .disposed(by: self.disposeBag)
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

private extension LoginViewController {
    func loginButtonDidTap() {
        let nonce = randomNonceString()
        self.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let nonce = self.currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let user = authResult?.user {
                self.viewModel?.checkRegistration(uid: user.uid)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
