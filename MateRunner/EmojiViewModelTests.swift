//
//  EmojiViewModelTests.swift
//  MateRunnerViewModelTests
//
//  Created by 이유진 on 2021/12/02.
//

import XCTest

import RxRelay
import RxSwift
import RxTest

final class EmojiViewModelTests: XCTestCase {
    private var viewModel: EmojiViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: EmojiViewModel.Input!
    private var output: EmojiViewModel.Output!
    
    override func setUpWithError() throws {
        self.viewModel = EmojiViewModel(
            coordinator: nil,
            emojiUseCase: MockEmojiUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }
    
    func test_emoji_selection() {
        let emojiCellTestableObservable = self.scheduler.createHotObservable([
            .next(20, IndexPath(row: 2, section: 0))
        ])
        
        let emojiSelectionTestableObserver = self.scheduler.createObserver(Emoji?.self)
        
        self.input = EmojiViewModel.Input(
            emojiCellTapEvent: emojiCellTestableObservable.asObservable()
        )
        
        self.viewModel.transform(from: input, disposeBag: self.disposeBag)
            .selectedEmoji
            .skip(1)
            .subscribe(emojiSelectionTestableObserver)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(emojiSelectionTestableObserver.events, [
            .next(20, Emoji.ribbonHeart)
        ])
    }
    
}
