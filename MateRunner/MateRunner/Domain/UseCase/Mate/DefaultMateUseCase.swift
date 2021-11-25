//
//  DefaultMateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultMateUseCase: MateUseCase {
    private let mateRepository: MateRepository
    private let firestoreRepository: FirestoreRepository
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    var mateList: PublishSubject<MateList> = PublishSubject()
    var didLoadMate: PublishSubject<Bool> = PublishSubject()
    var didRequestMate: PublishSubject<Bool> = PublishSubject()
    
    init(
        mateRepository: MateRepository,
        firestoreRepository: FirestoreRepository,
        userRepository: UserRepository
    ) {
        self.mateRepository = mateRepository
        self.firestoreRepository = firestoreRepository
        self.userRepository = userRepository
    }
    
    func fetchMateList() {
        self.firestoreRepository.fetchMate(of: "yujin")
            .subscribe(onNext: { [weak self] mate in
                self?.fetchMateImage(mate: mate ?? [])
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchMateInfo(name: String) {
        self.firestoreRepository.fetchFilteredMate(from: name, of: "yujin")
            .subscribe(onNext: { [weak self] mate in
                self?.fetchMateImage(mate: mate ?? [])
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchMateImage(mate: [String]) {
        var mateList: [String: String] = [:]
        Observable.zip( mate.map { nickname in
            self.firestoreRepository.fetchUserData(of: nickname)
                .map({ user in
                    mateList[nickname] = user.image
                })
        })
            .subscribe { [weak self] _ in
                self?.mateList.onNext(self?.sortedMate(list: mateList) ?? [])
                self?.didLoadMate.onNext(true)
            }
            .disposed(by: self.disposeBag)
    }
    
    func filterMate(base mate: MateList, from text: String) {
       self.filterText(mate, from: text)
            .subscribe { [weak self] mate in
                self?.mateList.onNext(mate)
            }
            .disposed(by: self.disposeBag)
    }
    
    func sendRequestMate(to mate: String) {
        self.mateRepository.fetchFCMToken(of: mate)
            .subscribe(onNext: { [weak self] token in
                self?.mateRepository.sendRequestMate(from: "yjsimul", fcmToken: token)
                    .subscribe(onNext: { [weak self] in
                        self?.saveRequestMate(to: mate)
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: self.disposeBag)
    }
    
    func saveRequestMate(to mate: String) {
        guard let userNickname = self.userRepository.fetchUserNickname() else { return }
        
        let notice = Notice(
            id: nil,
            sender: userNickname,
            receiver: mate,
            mode: NoticeMode.requestMate,
            isReceived: false
        )
        self.firestoreRepository.save(notice: notice, of: mate)
            .subscribe(onNext: { [weak self] in
                self?.didRequestMate.onNext(true)
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
