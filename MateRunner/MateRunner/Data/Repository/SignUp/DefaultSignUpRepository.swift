//
//  DefaultSignUpRepository.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/16.
//

import Foundation

import RxSwift

final class DefaultSignUpRepository: SignUpRepository {
    private let networkService: FireStoreNetworkService
    
    init(networkService: FireStoreNetworkService) {
        self.networkService = networkService
    }
    
    func checkDuplicate(of nickname: String) -> Observable<Bool> {
        return self.networkService.documentDoesExist(collection: "User", document: nickname)
    }
}
