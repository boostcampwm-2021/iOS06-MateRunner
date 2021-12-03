//
//  MockNotificationUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 이정원 on 2021/12/03.
//

import Foundation

import RxSwift

final class MockNotificationUseCase: NotificationUseCase {
    var notices = PublishSubject<[Notice]>()
    private var mockNotices = [
        Notice(
            id: "notice-1",
            sender: "Jungwon",
            receiver: "minji",
            mode: .requestMate,
            isReceived: false
        ),
        Notice(
            id: "notice-2",
            sender: "yujin",
            receiver: "hunhun",
            mode: .invite,
            isReceived: true
        ),
        Notice(
            id: "notice-3",
            sender: "Jungwon",
            receiver: "hunhun",
            mode: .receiveEmoji,
            isReceived: true
        )
    ]
    
    func fetchNotices() {
        self.notices.onNext(self.mockNotices)
    }
    
    func updateMateState(notice: Notice, isAccepted: Bool) {
        self.notices.onNext(self.mockNotices.map { $0.copyUpdatedReceived() })
    }
}
