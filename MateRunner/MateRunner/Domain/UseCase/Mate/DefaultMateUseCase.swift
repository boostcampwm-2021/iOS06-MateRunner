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
    var mate: BehaviorSubject<MateList> = BehaviorSubject(value: [])
    
    init(repository: MateRepository) {
        self.repository = repository
    }
    
    func fetchMateList() {
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
        guard let mate = try? self.mate.value() else { return }
        self.filterText(mate, from: text)
            .subscribe { [weak self] mate in
                self?.mate.onNext(mate)
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
    
    private func filterText(_ mate: MateList, from text: String) -> Observable<MateList> {
        var filteredMate:[(key: String, value: String)] = []
        mate.forEach {
            if $0.key.hasPrefix(text) {
                filteredMate.append((key: $0.key, value: $0.value))
            }
        }
        return Observable.of(filteredMate)
    }
    
    private func sortedMate(list: [String: String]) -> MateList {
        return list.sorted { $0.0 < $1.0 }
    }
}
