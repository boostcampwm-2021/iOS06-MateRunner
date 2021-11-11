//
//  DefaultMapUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

class DefaultMapUseCase: MapUseCase {
    private let repository: LocationRepository
    let updatedLocation: PublishRelay<CLLocation>
    var disposeBag: DisposeBag
    
    init(repository: LocationRepository) {
        self.repository = repository
        self.disposeBag = DisposeBag()
    }
    
    func requestLocation() {
        self.repository.fetchUpdatedLocation()
            .compactMap({ $0.last })
            .bind(to: self.updatedLocation)
            .disposed(by: self.disposeBag)
    }
}
