//
//  LocationService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/12.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var disposeBag: DisposeBag = DisposeBag()
        
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func fetchUpdatedLocation() -> Observable<CLLocation> {
        return PublishRelay<CLLocation>.create({ [weak self] emitter in
            self?.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap({ $0.first as? CLLocationManager })
                .compactMap({ $0.location })
                .subscribe(onNext: { location in
                    emitter.onNext(location)
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        })
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
        self.disposeBag = DisposeBag()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {}
}
