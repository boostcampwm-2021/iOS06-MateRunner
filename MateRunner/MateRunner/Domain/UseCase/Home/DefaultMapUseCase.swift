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
    weak var delegate: LocationDidUpdateDelegate?
    private let repository: LocationRepository
    var updatedLocation: PublishRelay<CLLocation>
    var disposeBag: DisposeBag
    
    required init(repository: LocationRepository, delegate: RunningUseCase) {
        self.repository = repository
        self.updatedLocation = PublishRelay()
        self.delegate = delegate
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
            .subscribe(onNext: { [weak self] location in
                self?.updatedLocation.accept(location)
                self?.delegate?.locationDidUpdate(location)
            })
            .disposed(by: self.disposeBag)
    }
}

