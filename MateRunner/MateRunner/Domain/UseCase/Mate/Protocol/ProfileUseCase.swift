//
//  ProfileUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/21.
//

import Foundation

import RxSwift

protocol ProfileUseCase: EmojiDidSelectDelegate {
    var userInfo: PublishSubject<UserData> { get set }
    var recordInfo: PublishSubject<[RunningResult]> { get set }
    var selectEmoji: PublishSubject<Emoji> { get set }
    func fetchUserInfo(_ nickname: String)
    func fetchRecordList(nickname: String)
    func fetchUserNickname() -> String?
    func emojiDidSelect(selectedEmoji: Emoji)
}
