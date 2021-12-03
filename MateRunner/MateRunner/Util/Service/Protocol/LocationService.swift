//
//  LocationService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

protocol LocationService {
    var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
    func start()
    func stop()
    func requestAuthorization()
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus>
    func observeUpdatedLocation() -> Observable<[CLLocation]>
}
