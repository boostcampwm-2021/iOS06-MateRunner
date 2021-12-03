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
    private let disposeBag = DisposeBag()
    
    init(
        myPageCoordinator: MyPageCoordinator?,
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
            .subscribe(onNext: { [weak self] in
                self?.myPageCoordinator?.pushNotificationViewController()
            })
            .disposed(by: disposeBag)
        
        input.profileEditButtonDidTapEvent
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let nickname = self?.myPageUseCase.nickname else { return }
                self?.myPageCoordinator?.pushProfileEditViewController(with: nickname)
            })
            .disposed(by: disposeBag)
        
        input.licenseButtonDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.myPageCoordinator?.pushLicenseViewController()
            })
            .disposed(by: disposeBag)
        
        self.myPageUseCase.imageURL
            .bind(to: output.imageURL)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func logout() {
        self.myPageUseCase.logout()
        self.myPageCoordinator?.finish()
    }
    
    func withdraw() {
        self.myPageUseCase.deleteUserData()
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.myPageCoordinator?.finish()
            })
            .disposed(by: self.disposeBag)
    }
}
