//
//  MyPageViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxRelay
import RxSwift

final class MyPageViewModel {
    private weak var myPageCoordinator: MyPageCoordinator?
    private let myPageUseCase: MyPageUseCase
    
    init(
        myPageCoordinator: MyPageCoordinator,
        myPageUseCase: MyPageUseCase
    ) {
        self.myPageCoordinator = myPageCoordinator
        self.myPageUseCase = myPageUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let notificationButtonDidTapEvent: Observable<Void>
        let profileEditButtonDidTapEvent: Observable<Void>
        let notificationSwitchValueDidChangeEvent: Observable<Bool>
        let licenseButtonDidTapEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<Void>
        let withdrawalButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var isNotificationOn = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe { _ in
                self.myPageUseCase.checkNotificationState()
            }
            .disposed(by: disposeBag)
        
        input.notificationButtonDidTapEvent
            .subscribe { _ in
                self.myPageCoordinator?.showNotificationFlow()
            }
            .disposed(by: disposeBag)
        
        input.profileEditButtonDidTapEvent
            .subscribe { _ in
                self.myPageCoordinator?.showProfileEditFlow()
            }
            .disposed(by: disposeBag)
        
        input.notificationSwitchValueDidChangeEvent
            .bind(onNext: { isOn in
                self.myPageUseCase.updateNotificationState(isOn: isOn)
            })
            .disposed(by: disposeBag)
        
        input.licenseButtonDidTapEvent
            .subscribe { _ in
                self.myPageCoordinator?.showLicenseFlow()
            }
            .disposed(by: disposeBag)
        
        self.myPageUseCase.isNotificationOn
            .bind(to: output.isNotificationOn)
            .disposed(by: disposeBag)
        
        return output
    }
}
