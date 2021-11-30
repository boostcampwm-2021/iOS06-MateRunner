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
    var nickname: String { get set }
    var height: BehaviorSubject<Double> { get }
    var weight: BehaviorSubject<Double> { get }
    var nicknameValidationState: BehaviorSubject<SignUpValidationState> { get }
    func validate(text: String)
    func signUp() -> Observable<Bool>
    func saveLoginInfo()
    func shuffleProfileEmoji()
}
