//
//  LoginViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import Foundation

import RxSwift

final class LoginViewModel {
    weak var coordinator: LoginCoordinator?
    private let loginUsCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: LoginCoordinator, loginUseCase: LoginUseCase) {
        self.coordinator = coordinator
        self.loginUsCase = loginUseCase
    }
    
    func checkRegistration(uid: String) {
        self.loginUsCase.isRegistered
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isRegistered in
                if isRegistered {
                    self?.loginUsCase.saveLoginInfo(uid: uid)
                } else {
                    self?.coordinator?.showSignUpFlow(with: uid)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.loginUsCase.isSaved
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.finish()
            })
            .disposed(by: self.disposeBag)
        
        self.loginUsCase.checkRegistration(uid: uid)
    }
}
