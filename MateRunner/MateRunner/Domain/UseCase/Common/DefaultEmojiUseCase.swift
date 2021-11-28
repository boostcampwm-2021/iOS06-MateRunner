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
    private let userRepository: UserRepository
    var selectedEmoji: PublishSubject<Emoji> = PublishSubject()
    weak var delegate: EmojiDidSelectDelegate?
    private let disposeBag = DisposeBag()
    private let selfNickname: String?
    var runningID: String?
    var mateNickname: String?
    
    init(
        firestoreRepository: FirestoreRepository,
        mateRepository: MateRepository,
        userRepository: UserRepository,
        delegate: EmojiDidSelectDelegate
    ) {
        self.firestoreRepository = firestoreRepository
        self.mateRepository = mateRepository
        self.userRepository = userRepository
        self.delegate = delegate
        self.selfNickname = self.userRepository.fetchUserNickname()
    }
    
    func saveSentEmoji(_ emoji: Emoji) {
        guard let runningID = self.runningID,
              let mate = self.mateNickname,
              let selfNickname = self.selfNickname else { return }
        
        self.firestoreRepository.save(
            emoji: emoji,
            to: mate,
            of: runningID,
            from: selfNickname
        ).subscribe(onNext: { [weak self] _ in
            self?.selectedEmoji.onNext(emoji)
        })
            .disposed(by: self.disposeBag)
    }
    
    func selectEmoji(_ emoji: Emoji) {
        self.delegate?.emojiDidSelect(selectedEmoji: emoji)
        self.selectedEmoji.onNext(emoji)
    }
    
    func sendComplimentEmoji() {
        guard let mateNickname = self.mateNickname,
              let selfNickname = self.selfNickname else { return }
        self.mateRepository.fetchFCMToken(of: mateNickname)
            .subscribe(onNext: { [weak self] token in
                self?.mateRepository.sendEmoji(from: selfNickname, fcmToken: token)
                    .subscribe()
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: self.disposeBag)
    }
    
}
