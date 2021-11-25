//
//  ProfileEditUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxSwift

protocol ProfileEditUseCase {
    var height: BehaviorSubject<Int?> { get set }
    var weight: BehaviorSubject<Int?> { get set }
    func getCurrentHeight()
    func getCurrentWeight()
    func loadUserInfo()
}
