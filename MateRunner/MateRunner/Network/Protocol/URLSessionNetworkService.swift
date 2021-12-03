//
//  URLSessionNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/20.
//

import Foundation

import RxSwift

protocol URLSessionNetworkService {
    func post<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func patch<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func delete(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func get(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
}
