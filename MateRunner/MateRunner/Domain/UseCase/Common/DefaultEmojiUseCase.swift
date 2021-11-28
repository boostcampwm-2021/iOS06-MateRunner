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
    private let mateRepository: MateRepository
    var selectedEmoji: PublishSubject<Emoji> = PublishSubject()
    weak var delegate: EmojiDidSelectDelegate?
    private let disposeBag = DisposeBag()
    var runningID: String?
    var mateNickname: String?
    
    init(
        firestoreRepository: FirestoreRepository,
        mateRepository: MateRepository,
        delegate: EmojiDidSelectDelegate
    ) {
        self.firestoreRepository = firestoreRepository
        self.mateRepository = mateRepository
        self.delegate = delegate
    }
    
    func saveSendEmoji(_ emoji: Emoji) {
        self.firestoreRepository.save(
            emoji: emoji,
            to: self.mateNickname ?? "",
            of: self.runningID ?? "",
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
    
    func sendComplimentEmoji(to mate: String) {
        self.mateRepository.fetchFCMToken(of: mate)
            .subscribe(onNext: { [weak self] token in
                self?.mateRepository.sendEmoji(from: "yujin", fcmToken: token)
                    .subscribe()
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: self.disposeBag)
    }
    
}
