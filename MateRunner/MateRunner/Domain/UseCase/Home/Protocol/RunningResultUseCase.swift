//
//  RunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/06.
//

import Foundation

import RxSwift
import RxRelay

protocol RunningResultUseCase: EmojiDidSelectDelegate {
    var runningResult: RunningResult { get set }
    var selectedEmoji: PublishRelay<Emoji> { get set }
    func saveRunningResult() -> Observable<Void>
    func fetchUserNickname() -> String?
}

extension RunningResultUseCase {
    func emojiDidSelect(selectedEmoji: Emoji) {
        self.selectedEmoji.accept(selectedEmoji)
    }
}
