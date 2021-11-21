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
    weak var delegate: EmojiDidSelectDelegate?
    
    init(delegate: EmojiDidSelectDelegate) {
        self.delegate = delegate
    }

    func sendEmoji(_ emoji: Emoji) {
        self.delegate?.emojiDidSelect(selectedEmoji: emoji)
        self.selectedEmoji.onNext(emoji)
    }
}
