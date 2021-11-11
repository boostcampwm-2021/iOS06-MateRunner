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

class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var disposeBag: DisposeBag = DisposeBag()
        
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.startUpdatingLocation()
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func observeUpdatedLocation() -> Observable<[CLLocation]> {
        return PublishRelay<[CLLocation]>.create({ emitter in
            self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap({ $0.last as? [CLLocation] })
                .subscribe(onNext: { location in
                    emitter.onNext(location)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {}
}
