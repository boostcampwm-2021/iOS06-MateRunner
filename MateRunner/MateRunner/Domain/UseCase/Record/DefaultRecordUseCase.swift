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
    
    var time = PublishSubject<Int>()
    var distance = PublishSubject<Double>()
    var calorie = PublishSubject<Double>()
    var userInfo = PublishSubject<UserProfileDTO>()
    var month = BehaviorSubject<Date?>(value: Date().startOfMonth)
    var selectedDay = BehaviorSubject<Date?>(value: Date())
    var runningCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loadCumulativeRecord() {
        guard let nickname = self.userRepository.fetchUserNickname() else { return }
        print("haha")
        self.userRepository.fetchUserInfo(nickname)
            .bind(to: self.userInfo)
            .disposed(by: self.disposeBag)
//        self.time.onNext(1234)
//        self.distance.onNext(42.19)
//        self.calorie.onNext(89.16)
    }
    
    func loadMonthRecord() {
        self.runningCount.onNext(15)
        self.likeCount.onNext(120)
    }
    
    func updateMonth(toNext: Bool) {
        guard let month = try? self.month.value() else { return }
        
        let updatedDate = toNext ? month.nextMonth?.startOfMonth : month.previousMonth?.startOfMonth
        self.selectedDay.onNext(updatedDate)
        self.month.onNext(updatedDate)
    }
}
