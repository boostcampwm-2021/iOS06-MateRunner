//
//  MyPageViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxCocoa
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
        let viewWillAppearEvent: Observable<Void>
        let notificationButtonDidTapEvent: Observable<Void>
        let profileEditButtonDidTapEvent: Observable<Void>
        let licenseButtonDidTapEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<Void>
        let withdrawalButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var nickname: String
        var imageURL = PublishRelay<String>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(
            nickname: self.myPageUseCase.nickname ?? "알 수 없는 사용자"
        )
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.myPageUseCase.loadUserInfo()
            })
            .disposed(by: disposeBag)
        
        input.notificationButtonDidTapEvent
            .subscribe { _ in
                self.myPageCoordinator?.showNotificationFlow()
            }
            .disposed(by: disposeBag)
        
        input.profileEditButtonDidTapEvent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let nickname = self?.myPageUseCase.nickname else { return }
                self?.myPageCoordinator?.showProfileEditFlow(with: nickname)
            })
            .disposed(by: disposeBag)
        
        input.licenseButtonDidTapEvent
            .subscribe { _ in
                self.myPageCoordinator?.showLicenseFlow()
            }
            .disposed(by: disposeBag)
        
        self.myPageUseCase.imageURL
            .bind(to: output.imageURL)
            .disposed(by: disposeBag)
        
        return output
    }
}
