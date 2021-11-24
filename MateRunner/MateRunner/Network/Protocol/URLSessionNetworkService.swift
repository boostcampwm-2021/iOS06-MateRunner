//
//  URLSessionNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/20.
//

import Foundation

import RxSwift

protocol URLSessionNetworkService {
    func post<T: Codable>(_ data: T, url urlString: String, headers: [String: String]?) -> Observable<Void>
    func get(url urlString: String) -> Observable<Data>
}
