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
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager?.stopUpdatingLocation()
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
    
    func fetchCurrentLocation() -> Observable<[CLLocation]> {
        self.locationManager?.requestLocation()
        return Observable<[CLLocation]>.create({ emitter in
            self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap({ $0.last as? [CLLocation] })
                .subscribe(onNext: { location in
                    emitter.onNext(location)
                    emitter.onCompleted()
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
