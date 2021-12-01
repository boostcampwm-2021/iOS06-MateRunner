//
//  MockMapUseCase.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

class MockMapUseCase: MapUseCase {
    var updatedLocation: PublishRelay<CLLocation>
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        self.updatedLocation = PublishRelay<CLLocation>()
    }
    
    required init(locationService: LocationService, delegate: LocationDidUpdateDelegate) {
        self.updatedLocation = PublishRelay<CLLocation>()
    }
    
    func executeLocationTracker() {
        self.updatedLocation.accept(CLLocation(latitude: 0, longitude: 0))
    }
    
    func terminateLocationTracker() {
        self.disposeBag = DisposeBag()
    }
    
    func requestLocation() {
        self.updatedLocation.accept(CLLocation(latitude: 1, longitude: 1))
    }
}
