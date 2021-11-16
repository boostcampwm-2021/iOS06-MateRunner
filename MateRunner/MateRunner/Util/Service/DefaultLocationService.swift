//
//  DefaultLocationService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/13.
//

import CoreLocation
import Foundation

import RxRelay
import RxSwift

final class DefaultLocationService: NSObject, LocationService {
    var locationManager: CLLocationManager?
    var disposeBag: DisposeBag = DisposeBag()
    var authorizationStatus = PublishRelay<CLAuthorizationStatus>()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.distanceFilter = CLLocationDistance(3)
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func requestAuthorization() -> Observable<CLAuthorizationStatus> {
        self.locationManager?.requestWhenInUseAuthorization()
        return self.authorizationStatus.asObservable()
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
}

extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {}
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus.accept(status)
    }
}
