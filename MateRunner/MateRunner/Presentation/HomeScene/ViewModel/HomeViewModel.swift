//
//  HomeViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    let homeUseCase: HomeUseCase
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let startButtonDidTapEvent: Observable<Void>
    }
    struct Output {
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe({ [weak self] _ in
                self?.homeUseCase.checkAuthorization()
                self?.homeUseCase.observeUserLocation()
            })
            .disposed(by: disposeBag)
        
        input.startButtonDidTapEvent
            .subscribe({ [weak self] _ in
                self?.homeUseCase.stopUpdatingLocation()
                self?.coordinator?.showSettingFlow()
            })
            .disposed(by: disposeBag)
        
        self.homeUseCase.authorizationStatus
            .map({ $0 == .disallowed })
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
        
        self.homeUseCase.userLocation
            .map({ $0.coordinate })
            .bind(to: output.currentUserLocation)
            .disposed(by: disposeBag)
        
        return output
    }
}
