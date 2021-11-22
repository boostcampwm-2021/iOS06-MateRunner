//
//  LoginCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import Foundation

protocol LoginCoordinator: Coordinator {
    func showSignUpFlow(with uid: String)
}
