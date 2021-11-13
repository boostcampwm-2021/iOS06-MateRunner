//
//  LocationService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxSwift

protocol LocationService {
    func start()
    func stop()
    func observeUpdatedLocation() -> Observable<[CLLocation]>
    func fetchCurrentLocation() -> Observable<[CLLocation]>
}
