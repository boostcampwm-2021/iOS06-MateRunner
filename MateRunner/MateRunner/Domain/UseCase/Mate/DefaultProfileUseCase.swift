//
//  DefaultProfileUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

import RxSwift

final class DefaultProfileUseCase: ProfileUseCase {
    private let repository: UserRepository
    private let disposeBag = DisposeBag()
    var userInfo: PublishSubject<UserProfileDTO> = PublishSubject()
    var recordInfo: PublishSubject<[RunningResult]> = PublishSubject()
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func fetchUserInfo(_ nickname: String) {
        self.repository.fetchUserInfo(nickname)
            .subscribe(onNext: { [weak self] mate in
                self?.userInfo.onNext(mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchRecordList(nickname: String) {
        self.repository.fetchRecordList(nickname)
            .map { self.resultToRecordList(from: $0) }
            .subscribe(onNext: { [weak self] records in
                self?.recordInfo.onNext(records)
            })
            .disposed(by: disposeBag)
    }
    
    func resultToRecordList(from result: UserResultDTO) -> [RunningResult] {
        var recordList: [RunningResult] = []
        result.records.values.forEach { record in
            recordList.append(record.toDomain())
        }
        return recordList
    }
}
