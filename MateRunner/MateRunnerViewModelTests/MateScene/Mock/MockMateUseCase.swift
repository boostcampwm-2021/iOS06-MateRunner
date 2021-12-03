//
//  MockMateUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/04.
//

import Foundation

import RxSwift

final class MockMateUseCase: MateUseCase {
    var mateList: PublishSubject<MateList>
    var didLoadMate: PublishSubject<Bool>
    var didRequestMate: PublishSubject<Bool>
    
    init() {
        self.mateList = PublishSubject()
        self.didLoadMate = PublishSubject()
        self.didRequestMate = PublishSubject()
    }
    
    func fetchMateList() {
        self.mateList.onNext([(key: "mateRunner", value: "profile")])
    }
    
    func fetchMateImage(from mate: [String]) {
        self.mateList.onNext([(key: "mateRunner", value: "profile")])
    }
    
    func fetchSearchedUser(with nickname: String) {
        self.mateList.onNext([(key: "mateRunner", value: "profile")])
        self.didLoadMate.onNext(true)
    }
    
    func sendRequestMate(to mate: String) {}
    
    func filterMate(base mate: MateList, from text: String) {
        self.didLoadMate.onNext(true)
    }
}
