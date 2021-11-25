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
    var imageURL: BehaviorSubject<String?> { get set }
    var saveResult: PublishSubject<Bool> { get set }
    func loadUserInfo()
    func saveUserInfo()
}
