//
//  NotificationViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxRelay
import RxSwift

final class NotificationViewModel {
    private weak var notificationCoordinator: MyPageCoordinator?
    private let notificationUseCase: NotificationUseCase
    var notices: [Notice] = []
    
    init(
        coordinator: MyPageCoordinator?,
        notificationUseCase: NotificationUseCase
    ) {
        self.notificationCoordinator = coordinator
        self.notificationUseCase = notificationUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        var didLoadData = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.notificationUseCase.fetchNotices()
            })
            .disposed(by: disposeBag)
        
        self.notificationUseCase.notices
            .subscribe(onNext: { [weak self] notices in
                self?.notices = notices.reversed()
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func updateMateState(notice: Notice, isAccepted: Bool) {
        self.notificationUseCase.updateMateState(notice: notice, isAccepted: true)
    }
}
