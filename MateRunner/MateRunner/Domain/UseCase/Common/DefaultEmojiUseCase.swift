//
//  DefaultEmojiUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import Foundation

import RxSwift

final class DefaultEmojiUseCase: EmojiUseCase {
    private let firestoreRepository: FirestoreRepository
    var selectedEmoji: PublishSubject<Emoji> = PublishSubject()
    weak var delegate: EmojiDidSelectDelegate?
    private let disposeBag = DisposeBag()
    
//    init(firestoreRepository: FirestoreRepository) {
//        self.firestoreRepository = firestoreRepository
//    }
    
    init(
        firestoreRepository: FirestoreRepository,
        delegate: EmojiDidSelectDelegate
    ) {
        self.firestoreRepository = firestoreRepository
        self.delegate = delegate
    }
    
    func sendEmoji(
        _ emoji: Emoji,
        to mateNickname: String,
        of runningID: String,
        from userNickname: String
    ) {
        self.firestoreRepository.save(
            emoji: emoji,
            to: mateNickname,
            of: runningID,
            from: "yujin"
        ).subscribe(onNext: { [weak self] _ in
            self?.selectedEmoji.onNext(emoji)
        })
            .disposed(by: self.disposeBag)
    }
    
    func selectEmoji(_ emoji: Emoji) {
        self.delegate?.emojiDidSelect(selectedEmoji: emoji)
        self.selectedEmoji.onNext(emoji)
    }
}
