//
//  SignUpRepository.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/16.
//

import Foundation

import RxSwift

protocol SignUpRepository {
    func checkDuplicate(of nickname: String) -> Observable<Bool>
    func saveUserInfo(nickname: String, height: Int, weight: Int) -> Observable<Bool>
    func saveLoginInfo(nickname: String)
}
