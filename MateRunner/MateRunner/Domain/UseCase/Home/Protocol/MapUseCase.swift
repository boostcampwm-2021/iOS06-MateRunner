//
//  MapUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxRelay

protocol MapUseCase {
    var updatedLocation: PublishRelay<CLLocation> { get set }
    init(repository: LocationRepository, delegate: LocationDidUpdateDelegate)
    func executeLocationTracker()
    func terminateLocationTracker()
    func requestLocation()
}
