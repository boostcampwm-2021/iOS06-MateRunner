//
//  MateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

protocol MateUseCase {
    typealias mateList = [(key: String, value: String)]
    var mate: PublishSubject<mateList> { get set }
    func fetchMateInfo()
    func fetchMateInfo(name: String)
    func sendRequestMate(to mate: String)
    func filteredMate(from text: String)
}
