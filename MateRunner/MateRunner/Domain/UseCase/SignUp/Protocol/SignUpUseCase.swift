//
//  SignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

protocol SignUpUseCase {
    var validText: PublishSubject<String?> { get set }
    var height: BehaviorSubject<Int> { get set }
    var weight: BehaviorSubject<Int> { get set }
    func validate(text: String)
    func getCurrentHeight()
    func getCurrentWeight()
}
