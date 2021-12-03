//
//  RunningResultUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/06.
//

import Foundation

import RxRelay
import RxSwift

protocol RunningResultUseCase: EmojiDidSelectDelegate {
    var runningResult: RunningResult { get set }
    var selectedEmoji: PublishRelay<Emoji> { get set }
    func saveRunningResult() -> Observable<Void>
}
