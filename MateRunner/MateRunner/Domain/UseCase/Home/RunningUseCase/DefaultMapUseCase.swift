//
//  DefaultMapUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

final class DefaultMapUseCase: MapUseCase {
    weak var delegate: LocationDidUpdateDelegate?
    private let locationService: LocationService
    var updatedLocation: PublishRelay<CLLocation>
    var disposeBag: DisposeBag
    
    required init(locationService: LocationService, delegate: LocationDidUpdateDelegate?) {
        self.locationService = locationService
        self.updatedLocation = PublishRelay()
        self.delegate = delegate
        self.disposeBag = DisposeBag()
    }
    
    func executeLocationTracker() {
        self.locationService.start()
    }
    
    func terminateLocationTracker() {
        self.locationService.stop()
    }
    
    func requestLocation() {
        self.locationService.observeUpdatedLocation()
            .compactMap({ $0.last })
            .subscribe(onNext: { [weak self] location in
                self?.updatedLocation.accept(location)
                self?.delegate?.locationDidUpdate(location)
            })
            .disposed(by: self.disposeBag)
    }
}
