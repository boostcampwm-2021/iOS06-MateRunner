//
//  MockFirestoreRepository.swift
//  MateRunnerUseCaseTests
//
//  Created by 이유진 on 2021/11/30.
//

import Foundation

import RxSwift

final class MockFirestoreRepository: FirestoreRepository {
    func save(runningResult: RunningResult, to userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchResult(of nickname: String, from startDate: Date, to endDate: Date) -> Observable<[RunningResult]> {
        return Observable.just([
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-Jungwon-20211130105106",
                    mode: .race,
                    targetDistance: 5.00,
                    hostNickname: "Jungwon",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ), userNickname: "Jungwon"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-Minji-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "Minji",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ), userNickname: "Minji"
            ),
            RunningResult(
                runningSetting: RunningSetting(
                    sessionId: "session-yujin-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "yujin",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ), userNickname: "yujin"
            )
        ])
    }
    
    func fetchResult(of nickname: String, from startOffset: Int, by limit: Int) -> Observable<[RunningResult]> {
        return Observable.just([
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
                    sessionId: "session-Minji-20211130105106",
                    mode: .team,
                    targetDistance: 3.00,
                    hostNickname: "Minji",
                    mateNickname: "hunhun",
                    dateTime: Date().startOfMonth
                ), userNickname: "Minji"
            )
        ])
    }
    
    func save(
        emoji: Emoji,
        to mateNickname: String,
        of runningID: String,
        from userNickname: String
    ) -> Observable<Void> {
        return Observable.just(())
    }
    
    func removeEmoji(from runningID: String, of mateNickname: String, with userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchEmojis(of runningID: String, from mateNickname: String) -> Observable<[String: Emoji]> {
        return Observable.just(["hunhun": .clap, "Minji": .ribbonHeart, "Jungwon": .fire])
    }
    
    func fetchUserProfile(of nickname: String) -> Observable<UserProfile> {
        return Observable.just(
            UserProfile(
                image: "https://firebasestorage.googleapis.com/profile",
                height: 170.0,
                weight: 60.0
            )
        )
    }
    
    func save(userProfile: UserProfile, of userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func save(totalRecord: PersonalTotalRecord, of nickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchTotalPeronsalRecord(of nickname: String) -> Observable<PersonalTotalRecord> {
        return nickname == "materunner" ? Observable.just(
            PersonalTotalRecord(distance: 56.0, time: 204, calorie: 1045.5)
        )  : Observable.error(MockError.unknown)
    }
    
    func save(user: UserData) -> Observable<Void> {
        return Observable.just(())
    }
    
    func remove(user nickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchUserData(of nickname: String) -> Observable<UserData> {
        return Observable.just(
            UserData(
                nickname: "materunner",
                image: "https://firebasestorage.googleapis.com/profile",
                time: 203,
                distance: 50.0,
                calorie: 400.3,
                height: 170.0,
                weight: 60.0,
                mate: ["Jungwon", "hunhun", "Minji", "Yujin"]
            )
        )
    }
    
    func fetchMate(of nickname: String) -> Observable<[String]> {
        return Observable.just(["Jungwon", "hunhun", "Minji", "Yujin"])
    }
    
    func fetchFilteredMate(from text: String, of nickname: String) -> Observable<[String]> {
        return Observable.just(["Jungwon", "hunhun", "Minji", "Yujin"])
    }
    
    func save(mate nickname: String, to targetNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func remove(mate nickname: String, from targetNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func saveAll(
        runningResult: RunningResult,
        personalTotalRecord: PersonalTotalRecord,
        userNickname: String
    ) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchNotice(of userNickname: String) -> Observable<[Notice]> {
        return Observable.just([
            Notice(
                id: "notice-1",
                sender: "Jungwon",
                receiver: "minji",
                mode: .requestMate,
                isReceived: false
            ),
            Notice(
                id: "notice-2",
                sender: "yujin",
                receiver: "hunhun",
                mode: .invite,
                isReceived: true
            ),
            Notice(
                id: "notice-3",
                sender: "Jungwon",
                receiver: "hunhun",
                mode: .receiveEmoji,
                isReceived: true
            )
        ])
    }
    
    func save(notice: Notice, of userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func updateState(notice: Notice, of userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func save(profileImageData: Data, of userNickname: String) -> Observable<String> {
        return Observable.just("https://firebasestorage.googleapis.com/profile")
    }
    
    func saveAll(userProfile: UserProfile, with newImageData: Data, of userNickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func save(uid: String, nickname: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchUserNickname(of uid: String) -> Observable<String> {
        return Observable.just("MateRunner")
    }
    
    func fetchUID(of nickname: String) -> Observable<String?> {
        return Observable.just("23edsgfd920sdxv")
    }
    
    func removeUID(uid: String) -> Observable<Void> {
        return Observable.just(())
    }
}
