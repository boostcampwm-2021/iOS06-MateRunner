//
//  MapViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

final class MapViewModel {
    let mapUseCase: MapUseCase
    
    struct Input {
        let viewDidAppearEvent: Observable<Void>
        let locateButtonDidTapEvent: Observable<Void>
        let backButtonDidTapEvent: Observable<Void>
        let panGestureDidRecognizedEvent: Observable<Void>
    }
    
    struct Output {
        let shouldSetCenter: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let shouldMoveToFirstPage: PublishRelay<Bool> = PublishRelay()
        let coordinatesToDraw: PublishRelay<(CLLocationCoordinate2D, CLLocationCoordinate2D)> = PublishRelay()
    }
    
    init(mapUseCase: MapUseCase) {
        self.mapUseCase = mapUseCase
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
        
        input.viewDidAppearEvent
            .subscribe(onNext: { [weak self] _ in
                output.shouldSetCenter.accept(true)
                self?.mapUseCase.executeLocationTracker()
                self?.mapUseCase.requestLocation()
            })
            .disposed(by: disposeBag)
        
        input.panGestureDidRecognizedEvent
            .map({ false })
            .bind(to: output.shouldSetCenter)
            .disposed(by: disposeBag)
        
        Observable.zip(
            self.mapUseCase.updatedLocation.asObservable(),
            self.mapUseCase.updatedLocation.skip(1).asObservable()
        )
            .map({ ($0.coordinate, $1.coordinate) })
            .bind(to: output.coordinatesToDraw)
            .disposed(by: disposeBag)
        
        return output
    }
}
