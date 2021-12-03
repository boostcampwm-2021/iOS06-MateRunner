//
//  MyPageUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxSwift

protocol MyPageUseCase {
    var nickname: String? { get }
    var imageURL: PublishSubject<String> { get set }
    func loadUserInfo()
    func logout()
    func deleteUserData() -> Observable<Bool>
}
