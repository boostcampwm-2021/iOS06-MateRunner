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
    var mateList: PublishSubject<MateList> { get set }
    var didLoadMate: PublishSubject<Bool> { get set }
    var didRequestMate: PublishSubject<Bool> { get set }
    func fetchMateList()
    func fetchSearchMate(name: String)
    func sendRequestMate(to mate: String)
    func filterMate(base mate: MateList, from text: String)
}
