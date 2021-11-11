//
//  DefaultLocationRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/11.
//

import CoreLocation
import Foundation

import RxSwift

class DefaultLocationRepository: LocationRepository {
    let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func fetchUpdatedLocation() -> Observable<[CLLocation]> {
        return self.locationService.observeUpdatedLocation()
    }
    
    func fetchCurrentLocation() -> Observable<[CLLocation]> {
        return Observable.just([CLLocation]())
    }
}
