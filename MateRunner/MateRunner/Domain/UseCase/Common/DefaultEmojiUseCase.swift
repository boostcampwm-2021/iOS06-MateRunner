//
//  DefaultEmojiUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import Foundation

import RxSwift

final class DefaultEmojiUseCase: EmojiUseCase {
    var selectedEmoji: PublishSubject<Emoji> = PublishSubject()

    func sendEmoji(_ emoji: Emoji) {
        self.selectedEmoji.onNext(emoji)
    }
}
