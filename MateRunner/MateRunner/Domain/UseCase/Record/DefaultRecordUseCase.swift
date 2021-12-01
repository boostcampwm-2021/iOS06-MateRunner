//
//  DefaultRecordUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/18.
//

import Foundation

import RxSwift

final class DefaultRecordUseCase: RecordUseCase {    
    private let userRepository: UserRepository
    private let firestoreRepository: FirestoreRepository
    private let disposeBag = DisposeBag()
    private let nickname: String?
    
    var totalRecord = PublishSubject<PersonalTotalRecord>()
    var month = BehaviorSubject<Date?>(value: Date().startOfMonth)
    var selectedDay = BehaviorSubject<Date?>(value: Date())
    var runningCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    var monthlyRecords = BehaviorSubject<[RunningResult]>(value: [])
    
    init(userRepository: UserRepository, firestoreRepository: FirestoreRepository) {
        self.userRepository = userRepository
        self.firestoreRepository = firestoreRepository
        self.nickname = self.userRepository.fetchUserNickname()
    }
    
    func loadTotalRecord() {
        guard let nickname = self.nickname else { return }
        
        self.firestoreRepository.fetchTotalPeronsalRecord(of: nickname)
            .subscribe(onNext: { [weak self] totalRecord in
                self?.totalRecord.onNext(totalRecord)
            })
            .disposed(by: self.disposeBag)
    }
    
    func refreshRecords() {
        self.month.onNext(try? self.month.value())
    }
    
    func loadMonthlyRecord() {
        guard let nickname = self.nickname,
              let currentMonth = try? self.month.value()?.startOfMonth,
              let nextMonth = currentMonth.nextMonth?.startOfMonth else { return }
        
        self.firestoreRepository.fetchResult(of: nickname, from: currentMonth, to: nextMonth)
            .debug()
            .subscribe(onNext: { [weak self] records in
                guard !records.isEmpty else {
                    guard let self = self else { return }
                    self.monthlyRecords.onNext([])
                    self.selectedDay.onNext(try? self.selectedDay.value())
                    self.runningCount.onNext(0)
                    self.likeCount.onNext(0)
                    return
                }
                
                Observable<RunningResult>.zip(records.map { [weak self] record in
                    self?.fetchRecordEmoji(record, from: nickname) ?? Observable.of(record)
                })
                    .subscribe(onNext: { [weak self] records in
                        guard let self = self else { return }
                        self.monthlyRecords.onNext(records)
                        self.selectedDay.onNext(try? self.selectedDay.value())
                        self.runningCount.onNext(records.count)
                        self.likeCount.onNext(self.getLikeCount(from: records))
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateMonth(toNext: Bool) {
        guard let month = try? self.month.value() else { return }
        
        let updatedDate = toNext ? month.nextMonth?.startOfMonth : month.previousMonth?.startOfMonth
        self.selectedDay.onNext(updatedDate)
        self.month.onNext(updatedDate)
    }
    
    private func fetchRecordEmoji(_ record: RunningResult, from nickname: String) -> Observable<RunningResult> {
        return self.firestoreRepository.fetchEmojis(of: record.runningID, from: nickname)
            .catchAndReturn([:])
            .map({ emoji -> RunningResult in
                let result = record
                result.updateEmoji(to: emoji)
                return result
            })
    }
                       
    private func getLikeCount(from list: [RunningResult]) -> Int {
        return list.map { runningResult in
            runningResult.emojis?.count ?? 0
        }.reduce(0, +)
    }
}
