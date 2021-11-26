//
//  EmojiUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/12.
//

import Foundation

import RxSwift

protocol EmojiUseCase {
    var selectedEmoji: PublishSubject<Emoji> { get set }
    func sendEmoji(
        _ emoji: Emoji,
        to mateNickname: String,
        of runningID: String,
        from userNickname: String
    )
    func selectEmoji(_ emoji: Emoji)
}
