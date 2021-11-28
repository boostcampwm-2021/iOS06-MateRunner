//
//  LoginUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/22.
//

import Foundation

import RxSwift

protocol LoginUseCase {
    var isRegistered: PublishSubject<Bool> { get set }
    var isSaved: PublishSubject<Bool> { get set }
    func checkRegistration(uid: String)
    func saveLoginInfo(uid: String)
    func saveFCMToken(of nickname: String)
}
