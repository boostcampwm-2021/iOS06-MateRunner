//
//  MockEmojiUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import Foundation

import RxSwift

final class MockEmojiUseCase: EmojiUseCase {
    var selectedEmoji: PublishSubject<Emoji>
    var runningID: String?
    var mateNickname: String?
    
    init() {
        self.selectedEmoji = PublishSubject()
        self.runningID = "running-id"
        self.mateNickname = "materunner"
    }
    
    func saveSentEmoji(_ emoji: Emoji) {
        self.selectedEmoji.onNext(emoji)
    }
    
    func selectEmoji(_ emoji: Emoji) {
        self.selectedEmoji.onNext(emoji)
    }
    
    func sendComplimentEmoji() {}
}
