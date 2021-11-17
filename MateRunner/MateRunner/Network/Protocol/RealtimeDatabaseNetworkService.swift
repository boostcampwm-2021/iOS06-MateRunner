//
//  RealtimeDatabaseNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/17.
//

import Foundation

import RxSwift

protocol RealtimeDatabaseNetworkService {
    func update(value: [String: Any], path: [String]) -> Observable<Bool>
}
