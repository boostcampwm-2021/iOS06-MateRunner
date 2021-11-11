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
    
    func transform(from input: Input, disposeBag: DisposeBag) {
        input.emojiCellTapEvent
            .subscribe(onNext: { [weak self] index in
                print(index.row)
            })
            .disposed(by: disposeBag)
        
//        return createOutput(from: input, disposeBag: disposeBag)
    }
}

private extension EmojiViewModel {
    func 
}
