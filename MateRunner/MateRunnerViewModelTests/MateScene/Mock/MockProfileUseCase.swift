//
//  MockProfileUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/03.
//

import Foundation

import RxSwift

final class MockProfileUseCase: ProfileUseCase {
    var userInfo: PublishSubject<UserData>
    var recordInfo: PublishSubject<[RunningResult]>
    var selectEmoji: PublishSubject<Emoji>
    
    init() {
        self.userInfo = PublishSubject()
        self.recordInfo = PublishSubject()
        self.selectEmoji = PublishSubject()
    }
    
    func fetchUserInfo(_ nickname: String) {
        self.userInfo.onNext(
            UserData(
                nickname: "materunner",
                image: "profile.png",
                time: 15,
                distance: 2.0,
                calorie: 5.0,
                height: 170.0,
                weight: 60.0,
                mate: ["apple"])
        )
    }
    
    func fetchRecordList(nickname: String, from index: Int, by count: Int) {
        if index == 0 {
            self.recordInfo.onNext([
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-yujin-20211130105106",
                        mode: .race,
                        targetDistance: 5.00,
                        hostNickname: "yujin",
                        mateNickname: "Minji",
                        dateTime: Date().startOfMonth
                    ), userNickname: "yujin"
                ),
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-hunhun-20211130105106",
                        mode: .team,
                        targetDistance: 3.00,
                        hostNickname: "hunhun",
                        mateNickname: "Jungwon",
                        dateTime: Date().startOfMonth
                    ), userNickname: "hunhun"
                ),
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-yujin-20211130105106",
                        mode: .race,
                        targetDistance: 5.00,
                        hostNickname: "yujin",
                        mateNickname: "Minji",
                        dateTime: Date().startOfMonth
                    ), userNickname: "yujin"
                ),
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-hunhun-20211130105106",
                        mode: .team,
                        targetDistance: 3.00,
                        hostNickname: "hunhun",
                        mateNickname: "Jungwon",
                        dateTime: Date().startOfMonth
                    ), userNickname: "hunhun"
                ),
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-yujin-20211130105106",
                        mode: .race,
                        targetDistance: 5.00,
                        hostNickname: "yujin",
                        mateNickname: "Minji",
                        dateTime: Date().startOfMonth
                    ), userNickname: "yujin"
                )]
            )
        } else {
            self.recordInfo.onNext([
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-mate-20211130105106",
                        mode: .race,
                        targetDistance: 5.00,
                        hostNickname: "mate",
                        mateNickname: "runner",
                        dateTime: Date().startOfMonth
                    ), userNickname: "mate"
                ),
                RunningResult(
                    runningSetting: RunningSetting(
                        sessionId: "session-apple-20211130105106",
                        mode: .team,
                        targetDistance: 3.00,
                        hostNickname: "apple",
                        mateNickname: "garden",
                        dateTime: Date().startOfMonth
                    ), userNickname: "apple"
                )]
            )
        }
    }
    
    func fetchUserNickname() -> String? {
        return "applegarden"
    }
    
    func emojiDidSelect(selectedEmoji: Emoji) {
        self.selectEmoji.onNext(.clap)
    }
    
    func deleteEmoji(from runningID: String, of mate: String) -> Observable<Void> {
        return Observable.just(())
    }
}
