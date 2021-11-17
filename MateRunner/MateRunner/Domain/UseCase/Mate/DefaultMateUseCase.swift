//
//  DefaultMateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class DefaultMateUseCase: MateUseCase {
    private let repository: MateRepository
    private let disposeBag = DisposeBag()
    private var mateList: [String: String] = [:]
    var mate: PublishSubject<[String: String]> = PublishSubject()
    
    init(repository: MateRepository) {
        self.repository = repository
    }
    
    func fetchMateInfo() {
        self.repository.fetchMateNickname()
            .subscribe(onNext: { [weak self] mate in
                self?.fetchMateImage(mate: mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchMateImage(mate: [String]) {
        Observable.zip( mate.map { nickname in
            self.repository.fetchMateProfileImage(from: nickname)
                .map({ [weak self] url in
                    self?.mateList[url] = nickname
                })
        })
            .subscribe { [weak self] _ in
                self?.mate.onNext(self?.mateList ?? [:])
            }
            .disposed(by: self.disposeBag)
    }
}
