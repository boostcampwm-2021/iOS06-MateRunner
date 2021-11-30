//
//  SignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

protocol SignUpUseCase {
    var selectedProfileEmoji: BehaviorSubject<String> { get }
    var nickname: BehaviorSubject<String> { get}
    var height: BehaviorSubject<Double> { get }
    var weight: BehaviorSubject<Double> { get }
    var signUpResult: PublishSubject<Bool> { get }
    func validate(text: String)
    func checkDuplicate(of nickname: String) -> Observable<Bool>
    func signUp() -> Observable<Bool>
}
