//
//  FirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

import RxSwift

protocol FirestoreRepository {
    // MARK: - Running Result Update/Read
    func save(
        runningResult: RunningResult,   // 달리기 결과
        to userNickname: String         // 달리기를 등록할 사용자의 닉네임
    ) -> Observable<Void>
    func fetchResult(
        of nickname: String,            // 조회할 사용자의 닉네임
        from startDate: Date,           // 필터링 시작 날짜
        to endDate: Date                // 필터링 끝 날짜
    ) -> Observable<[RunningResult]>
    func fetchResult(
        of nickname: String,            // 조회할 사용자의 닉네임
        from startOffset: Int,          // 조회를 시작할 인덱스
        by limit: Int                   // 한번에 가져올 최대 개수
    ) -> Observable<[RunningResult]>
    
    // MARK: - Emoji Update/Read/Delete
    func save(
        emoji: Emoji,                   // 추가할 이모지
        to mateNickname: String,        // 이모지를 보낼 대상의 닉네임
        of runningID: String,           // 이모지를 보낼 달리기 기록 아이디
        from userNickname: String       // 자기자신의 아이디
    ) -> Observable<Void>
    func removeEmoji(
        from runningID: String,         // 이모지를 삭제할 달리기 기록 아이디
        of mateNickname: String,        // 이모지를 삭제할 메이트의 닉네임
        with userNickname: String       // 이모지를 준 사람의 닉네임
    ) -> Observable<Void>
    func fetchEmojis(
        of runningID: String,           // 이모지를 가져올 달리기 기록의 아이디
        from mateNickname: String       // 달리기 기록을 가진 메이트의 닉네임
    ) -> Observable<[String: Emoji]>
    
    // MARK: - UserInformation Read/Update/Delete
    func fetchUserProfile(
        of nickname: String
    ) -> Observable<UserProfile>
    func save(
        userProfile: UserProfile,       // 추가할 사용자 프로필(키, 몸무게, 프사) 정보 객체
        of userNickname: String         // 추가할 사용자의 닉네임
    ) -> Observable<Void>
    
    // MARK: - TotalRecord Update/Read
    func save(
        totalRecord: PersonalTotalRecord,  // 추가할 누적기록 객체(거리, 시간, 칼로리)
        of nickname: String                // 누적기록을 추가할 사용자의 닉네임
    ) -> Observable<Void>
    func fetchTotalPeronsalRecord(
        of nickname: String                // 누적기록을 가져올 사용자의 닉네임
    ) -> Observable<PersonalTotalRecord>
    
    // MARK: - User Read/Update/Delete
    func save(
        user: UserData                     // 추가할 전체 사용자 정보 객체
    ) -> Observable<Void>
    func remove(
        user nickname: String)             // 전체 사용자 정보를 삭제할 사용자의 닉네임
    -> Observable<Void>
    func fetchUserData(
        of nickname: String             // 정보를 가져올 사용자의 닉네임
    ) -> Observable<UserData>
    
    // MARK: - Mate Read/Update/Delete
    func fetchMate(
        of nickname: String                // 메이트목록을 가져올 사용자의 닉네임
    ) -> Observable<[String]>
    func fetchFilteredMate(
        from text: String,                 // 필터링 기준 텍스트
        of nickname: String                // 메이트목록을 가져올 사용자의 닉네임
    ) -> Observable<[String]>
    func save(
        mate nickname: String,             // 메이트로 추가할 사용자의 닉네임
        to targetNickname: String          // 대상 사용자의 닉네임
    ) -> Observable<Void>
    func remove(
        mate nickname: String,             // 제거할 메이트의 닉네임
        from targetNickname: String        // 친구를 제거할 대상 사용자의 닉네임
    ) -> Observable<Void>
    func saveAll(
        runningResult: RunningResult,             // 저장할 달리기 결과
        personalTotalRecord: PersonalTotalRecord, // 저장할 누적기록
        userNickname: String                      // 저장할 사용자의 이름
    ) -> Observable<Void>
    
    // MARK: - Notice fetch/save/update
    func fetchNotice(
        of userNickname: String
    ) -> Observable<[Notice]>
    func save(
        notice: Notice,
        of userNickname: String
    ) -> Observable<Void>
    func updateState(
        notice: Notice,
        of userNickname: String
    ) -> Observable<Void>
    
    // MARK: - ProfileImage Read/Update
    func save(
        profileImageData: Data,             // 저장할 프사(png)
        of userNickname: String             // 프사를 저장할 사용자의 닉네임
    ) -> Observable<String>
    func saveAll(                           // 프로필 사진을 업데이트 할 때만 사용
        userProfile: UserProfile,           // 업데이트할 프로필
        with newImageData: Data,            // 업데이트할 이미지
        of userNickname: String             // 상용자 닉네임
    ) -> Observable<Void>
    
    func save(
        uid: String,
        nickname: String
    ) -> Observable<Void>
    
    func fetchUserNickname(
        of uid: String
    ) -> Observable<String>
}
