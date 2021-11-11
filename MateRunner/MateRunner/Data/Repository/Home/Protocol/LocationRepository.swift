//
//  LocationRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/11.
//

import CoreLocation
import Foundation

import RxSwift

protocol LocationRepository {
    func fetchUpdatedLocation() -> Observable<[CLLocation]>
    func fetchCurrentLocation() -> Observable<[CLLocation]>
}
