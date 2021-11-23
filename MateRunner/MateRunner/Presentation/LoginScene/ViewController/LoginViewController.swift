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
        self.configureUI()
        self.bindUI()
    }
}

private extension LoginViewController {
    func configureUI() {
        self.view.backgroundColor = .mrYellow
        
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
