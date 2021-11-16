//
//  DefaultMateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class DefaultMateUseCase: MateUseCase {
    let repository = DefaultMateRepository()
    private let disposeBag = DisposeBag()
    
    var mateNickname: PublishSubject<[String]> = PublishSubject()
    var mate: BehaviorSubject<[String: String]> = BehaviorSubject(value: [:])
    
    func fetchMateInfo() {
        self.repository.fetchMateNickname()
            .subscribe(onNext: { mate in
                print(mate)
                self.mateNickname.onNext(mate)
            })
            .disposed(by: self.disposeBag)
    }
}
