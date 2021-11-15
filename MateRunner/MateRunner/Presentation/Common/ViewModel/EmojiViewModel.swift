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
    private let emojiUseCase: EmojiUseCase
//    private weak var coordinator: RunningSettingCoordinator? //코디네이터는 이름이 어떨지 몰라서 일단 주석처리 해둡니다!
    
    struct Input {
      let emojiCellTapEvent: Observable<IndexPath>
    }
    
    struct Output {
      @BehaviorRelayProperty var selectedEmoji: Emoji?
      var dismissModal: PublishRelay<Bool> = PublishRelay<Bool>()
    }
    
    init(
        //        coordinator: RunningSettingCoordinator,
        emojiUseCase: EmojiUseCase
    ) {
        //        self.coordinator = coordinator
        self.emojiUseCase = emojiUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.emojiCellTapEvent
            .subscribe(onNext: { [weak self] indexPath in
                guard let emoji = self?.emoji(at: indexPath.row) else { return }
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
    func emoji(at index: Int) -> Emoji {
        return Emoji.allCases[index]
    }
}
