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
        let viewDidLoadEvent: Observable<Void>
        let notificationButtonDidTapEvent: Observable<Void>
        let profileEditButtonDidTapEvent: Observable<Void>
        let licenseButtonDidTapEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<Void>
        let withdrawalButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var nickname = BehaviorRelay<String>(value: "")
        var imageURL = BehaviorRelay<String>(value: "")
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
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
        
        Observable.just(self.myPageUseCase.nickname)
            .compactMap { $0 }
            .bind(to: output.nickname)
            .disposed(by: disposeBag)
        
        self.myPageUseCase.imageURL
            .bind(to: output.imageURL)
            .disposed(by: disposeBag)
        
        return output
    }
}
