//
//  HomeUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/17.
//

import CoreLocation
import Foundation

import RxSwift

protocol HomeUseCase {
    var authorizationStatus: BehaviorSubject<LocationAuthorizationStatus?> { get set }
    var userLocation: PublishSubject<CLLocation> { get set }
    init(locationService: LocationService)
    func checkAuthorization()
    func observeUserLocation()
    func stopUpdatingLocation()
}
