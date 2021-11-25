//
//  ProfileEditUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

protocol ProfileEditUseCase {
    var nickname: String? { get }
    var height: BehaviorSubject<Double?> { get set }
    var weight: BehaviorSubject<Double?> { get set }
    func getCurrentHeight()
    func getCurrentWeight()
    func loadUserInfo()
}
