//
//  DefaultProfileUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

import RxSwift

final class DefaultProfileUseCase: ProfileUseCase {
    private let fireStoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()
    var userInfo: PublishSubject<UserData> = PublishSubject()
    var recordInfo: PublishSubject<[RunningResult]> = PublishSubject()
    
    init(fireStoreRepository: FirestoreRepository) {
        self.fireStoreRepository = fireStoreRepository
    }
    
    func fetchUserInfo(_ nickname: String) {
        self.fireStoreRepository.fetchUserData(of: nickname)
            .subscribe(onNext: { [weak self] mate in
                guard let mate = mate else { return }
                self?.userInfo.onNext(mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchRecordList(nickname: String) {
        self.fireStoreRepository.fetchResult(of: nickname, from: 0, by: 10)
            .subscribe(onNext: { [weak self] records in
                self?.recordInfo.onNext(records ?? [])
            })
            .disposed(by: disposeBag)
    }
    
//    func resultToRecordList(from result: UserResultDTO) -> [RunningResult] {
//        var recordList: [RunningResult] = []
//        result.records.values.forEach { record in
//            recordList.append(record.toDomain())
//        }
//        return recordList
//    }
}
