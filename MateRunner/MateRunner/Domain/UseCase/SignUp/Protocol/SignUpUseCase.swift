//
//  SignUpUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/15.
//

import Foundation

import RxSwift

protocol SignUpUseCase {
    var height: BehaviorSubject<Int> { get set }
    var weight: BehaviorSubject<Int> { get set }
    func getCurrentHeight()
    func getCurrentWeight()
}
