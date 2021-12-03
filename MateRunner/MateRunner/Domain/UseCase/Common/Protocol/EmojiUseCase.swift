//
//  EmojiUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/12.
//

import Foundation

import RxSwift

protocol EmojiUseCase {
    var selectedEmoji: PublishSubject<Emoji> { get set }
    func saveSentEmoji(_ emoji: Emoji)
    func selectEmoji(_ emoji: Emoji)
    func sendComplimentEmoji()
    var runningID: String? { get set }
    var mateNickname: String? { get set }
}
