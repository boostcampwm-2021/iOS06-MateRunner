//
//  LoginViewModel.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import Foundation

final class LoginViewModel {
    weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func loginButtonDidTap() {
        self.coordinator?.showSignUpFlow()
    }
}
