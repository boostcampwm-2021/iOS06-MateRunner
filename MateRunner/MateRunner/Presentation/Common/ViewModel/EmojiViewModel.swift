//
//  EmojiViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/11.
//

import Foundation

import RxSwift
import RxCocoa

final class EmojiViewModel {
//    weak var coordinator: RunningCoordinator?
    private let emojiUseCase = DefaultEmojiUseCase()
    
    struct Input {
        let emojiCellTapEvent: Observable<IndexPath>
    }
    
    struct Output {
        @BehaviorRelayProperty var selectedEmoji: Emoji?
        var dismissModal: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
//    init(coordinator: RunningCoordinator, emojiUseCase: EmojiUseCase) {
//        self.coordinator = coordinator
//        self.emojiUseCase = emojiUseCase
//    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.emojiCellTapEvent
            .subscribe(onNext: { [weak self] indexPath in
                guard let emoji = self?.indexToEmoji(index: indexPath.row) else { return }
                self?.emojiUseCase.sendEmoji(emoji)
            })
            .disposed(by: disposeBag)
      
        self.emojiUseCase.selectedEmoji
            .bind(to: output.$selectedEmoji)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension EmojiViewModel {
    func indexToEmoji(index: Int) -> Emoji {
        return Emoji.allCases[index]
    }
}
