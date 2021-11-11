//
//  MapViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

class MapViewModel {
    let mapUseCase: MapUseCase
    
    init(mapUseCase: MapUseCase) {
        self.mapUseCase = mapUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let locateButtonDidTapEvent: Observable<Void>
        let backButtonDidTapEvent: Observable<Void>
        let panGestureDidRecognizedEvent: Observable<Void>
    }
    
    struct Output {
        let shouldSetCenter: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let shouldMoveToFirstPage: PublishRelay<Bool> = PublishRelay()
        let updatedCoordinate: BehaviorRelay<CLLocation> = BehaviorRelay(value: CLLocation())
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.backButtonDidTapEvent
            .map({ true })
            .bind(to: output.shouldMoveToFirstPage)
            .disposed(by: disposeBag)
        
        input.locateButtonDidTapEvent
            .map({ true })
            .bind(to: output.shouldSetCenter)
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.mapUseCase.executeLocationTracker()
                self?.mapUseCase.requestLocation()
            })
            .disposed(by: disposeBag)
        
        input.panGestureDidRecognizedEvent
            .map({ false })
            .bind(to: output.shouldSetCenter)
            .disposed(by: disposeBag)
        
        self.mapUseCase.updatedLocation
            .bind(to: output.updatedCoordinate)
            .disposed(by: disposeBag)
        
        
        return output
    }
}
