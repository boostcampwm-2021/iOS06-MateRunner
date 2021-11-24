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
    private let disposeBag = DisposeBag()
    private let nickname: String?
    
    var time = PublishSubject<Int>()
    var distance = PublishSubject<Double>()
    var calorie = PublishSubject<Double>()
    var userInfo = PublishSubject<UserProfileDTO>()
    var month = BehaviorSubject<Date?>(value: Date().startOfMonth)
    var selectedDay = BehaviorSubject<Date?>(value: Date())
    var runningCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    var montlyRecords = BehaviorSubject<[RunningResult]>(value: [])
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.nickname = self.userRepository.fetchUserNickname()
    }
    
    func loadCumulativeRecord() {
        guard let nickname = self.nickname else { return }
        
        self.userRepository.fetchUserInfo(nickname)
            .bind(to: self.userInfo)
            .disposed(by: self.disposeBag)
    }
    
    func refresh() {
        self.month.onNext(try? self.month.value())
    }
    
    func loadMonthlyRecord() {
        // 나중에 한달에 대한 기록을 가져오면 여기에 구현할 예정
    }
    
    func updateMonth(toNext: Bool) {
        guard let month = try? self.month.value() else { return }
        
        let updatedDate = toNext ? month.nextMonth?.startOfMonth : month.previousMonth?.startOfMonth
        self.selectedDay.onNext(updatedDate)
        self.month.onNext(updatedDate)
    }
    
    func fetchRecordList() {
        guard let nickname = self.nickname else { return }

        self.userRepository.fetchRecordList(nickname)
            .compactMap { [weak self] in
                self?.resultToRecordList(from: $0)
            }
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                self.montlyRecords.onNext(list)
                self.runningCount.onNext(list.count)
                self.likeCount.onNext(self.getLikeCount(from: list))
                self.selectedDay.onNext(try? self.selectedDay.value())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func resultToRecordList(from result: UserResultDTO) -> [RunningResult] {
        var recordList: [RunningResult] = []
        result.records.values.forEach { record in
            recordList.append(record.toDomain())
        }

        return recordList
    }
                       
    private func getLikeCount(from list: [RunningResult]) -> Int {
        return list.map { runningResult in
            runningResult.emojis?.count ?? 0
        }.reduce(0, +)
    }
}
