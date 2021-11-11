//
//  DefaultEmojiUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import Foundation

import RxSwift

final class DefaultEmojiUseCase {
    var selectedEmoji: BehaviorSubject<Emoji> = BehaviorSubject(value: Emoji.clap)

    func sendEmoji(_ emoji: Emoji) {
        // send emoji
        self.selectedEmoji.onNext(emoji)
    }
}
