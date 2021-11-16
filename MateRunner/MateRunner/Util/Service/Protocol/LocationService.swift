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
    var authorizationStatus: PublishRelay<CLAuthorizationStatus> { get set }
    func start()
    func stop()
    func requestAuthorization() -> Observable<CLAuthorizationStatus>
    func observeUpdatedLocation() -> Observable<[CLLocation]>
}
