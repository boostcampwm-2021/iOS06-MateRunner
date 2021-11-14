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

class DefaultMapUseCase: MapUseCase {
    private let repository: LocationRepository
    var updatedLocation: PublishRelay<CLLocation>
    var disposeBag: DisposeBag
    
    required init(repository: LocationRepository) {
        self.repository = repository
        self.updatedLocation = PublishRelay()
        self.disposeBag = DisposeBag()
    }
    
    func executeLocationTracker() {
        self.repository.executeLocationService()
    }
    
    func terminateLocationTracker() {
        self.repository.terminateLocationService()
    }
    
    func requestLocation() {
        self.repository.fetchUpdatedLocation()
            .compactMap({ $0.last })
            .bind(to: self.updatedLocation)
            .disposed(by: self.disposeBag)
    }
}
