//
//  MateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

protocol MateUseCase {
    typealias MateList = [(key: String, value: String)]
    var mate: BehaviorSubject<MateList> { get set }
    func fetchMateList()
    func fetchMateInfo(name: String)
    func sendRequestMate(to mate: String)
    func filteredMate(from text: String)
}
