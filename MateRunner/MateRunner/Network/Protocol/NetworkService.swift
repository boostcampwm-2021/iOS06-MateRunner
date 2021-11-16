//
//  NetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

protocol NetworkService {
    func fetchData<T>(
        type: T.Type,
        collection: String,
        document: String,
        field: String
    ) -> Observable<T>
}
