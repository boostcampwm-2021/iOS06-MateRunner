//
//  MateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

protocol MateUseCase {
    var mate: BehaviorSubject<[String: String]> { get set }
    func fetchMateInfo()
}
