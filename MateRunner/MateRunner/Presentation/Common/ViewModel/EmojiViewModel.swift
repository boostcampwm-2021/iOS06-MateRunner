//
//  EmojiViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import Foundation

import RxCocoa
import RxSwift

final class EmojiViewModel {
    let emojiObservable = Observable.of(Emoji.allCases)
    var emojiUseCase: EmojiUseCase
    private weak var coordinator: EmojiCoordinator?
    
    struct Input {
      let emojiCellTapEvent: Observable<IndexPath>
    }
    
    struct Output {
      @BehaviorRelayProperty var selectedEmoji: Emoji?
      var dismissModal: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    init(
        coordinator: EmojiCoordinator,
        emojiUseCase: DefaultEmojiUseCase
    ) {
        self.coordinator = coordinator
        self.emojiUseCase = emojiUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.emojiCellTapEvent
            .subscribe(onNext: { [weak self] indexPath in
                guard let emoji = self?.emoji(at: indexPath.row) else { return }
                self?.emojiUseCase.saveSentEmoji(emoji)
                self?.emojiUseCase.selectEmoji(emoji)
                self?.emojiUseCase.sendComplimentEmoji(to: "yjsimul")
            })
            .disposed(by: disposeBag)
      
        self.emojiUseCase.selectedEmoji
            .bind(to: output.$selectedEmoji)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension EmojiViewModel {
    func emoji(at index: Int) -> Emoji {
        return Emoji.allCases[index]
    }
}
