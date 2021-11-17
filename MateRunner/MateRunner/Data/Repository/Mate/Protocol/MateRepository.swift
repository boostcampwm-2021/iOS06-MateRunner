//
//  MateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import Foundation

import RxSwift

protocol MateRepository {
    func fetchMateNickname() -> Observable<[String]>
    func fetchMateProfileImage(from nickname: String) -> Observable<String>
    func fetchFilteredNickname()
}
