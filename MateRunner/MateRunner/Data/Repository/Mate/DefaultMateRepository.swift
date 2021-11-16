//
//  DefaultMateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/16.
//

import Foundation

import RxSwift

final class DefaultMateRepository {
    let networkService = FireStoreNetworkService()
    
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
    
    func fetchMateNickname() -> Observable<[String]> {
        return self.networkService.fetchMate(collection: "User", document: "yujin")
    }
}
