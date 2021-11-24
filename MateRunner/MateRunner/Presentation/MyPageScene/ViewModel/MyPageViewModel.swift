//
//  MyPageViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

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
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}