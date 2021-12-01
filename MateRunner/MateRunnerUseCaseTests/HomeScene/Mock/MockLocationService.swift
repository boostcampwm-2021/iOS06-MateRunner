//
//  MockLocationService.swift
//  MateRunnerViewModelTests
//
//  Created by 전여훈 on 2021/12/01.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

final class MockLocationService: LocationService {
    var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
    func start() {}
    
    func stop() {}
    
    func requestAuthorization() {}
    
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus> {
        return Observable.just(.notDetermined)
    }
    
    func observeUpdatedLocation() -> Observable<[CLLocation]> {
        return Observable.just([CLLocation(latitude: 1, longitude: 1)])
    }
}
