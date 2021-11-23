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
    var mate: PublishSubject<mateList> = PublishSubject()
    
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
    
    func fetchMateInfo(name: String) {
        self.repository.fetchFilteredNickname(text: name)
            .subscribe(onNext: { [weak self] mate in
                self?.fetchMateImage(mate: mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchMateImage(mate: [String]) {
        var mateList: [String: String] = [:]
        Observable.zip( mate.map { nickname in
            self.repository.fetchMateProfileImage(from: nickname)
                .map({ url in
                    mateList[nickname] = url
                })
        })
            .subscribe { [weak self] _ in
                self?.mate.onNext(self?.sortedMate(list: mateList) ?? [])
            }
            .disposed(by: self.disposeBag)
    }
    
    func filteredMate(from text: String) {
        self.mate
            .subscribe { [weak self] mate in
                self?.mate.onNext(self?.filterText(mate, from: text) ?? [])
            }
            .disposed(by: self.disposeBag)
    }
    
    func sendRequestMate(to mate: String) {
        self.repository.fetchFCMToken(of: mate)
            .subscribe(onNext: { [weak self] token in
                self?.repository.sendRequestMate(from: "yujin", fcmToken: token)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func filterText(_ mate: mateList, from text: String) -> mateList {
        var filteredMate:[(key: String, value: String)] = []
        mate.forEach {
            if $0.key.hasPrefix(text) {
                filteredMate.append((key: $0.key, value: $0.value))
            }
        }
        return filteredMate
    }
    
    private func sortedMate(list: [String: String]) -> mateList {
        return list.sorted { $0.0 < $1.0 }
    }
}

