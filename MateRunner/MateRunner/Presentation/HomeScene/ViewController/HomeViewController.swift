//
//  HomeViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.startMonitoringSignificantLocationChanges()
        manager.delegate = self
        return manager
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        return map
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("달리기", for: .normal)
        button.titleLabel?.font = UIFont.notoSans(size: 20, family: .bold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 60
        button.layer.backgroundColor = UIColor.mrYellow.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.getLocationUsagePermission()
        self.bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            getLocationUsagePermission()
        case .denied:
            getLocationUsagePermission()
        default:
            break
        }
    }
    
    func myLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double) {
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mapView.setRegion(locationRegion, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        guard let latitude = lastLocation?.coordinate.latitude else { return }
        guard let longitude = lastLocation?.coordinate.longitude else { return }
        myLocation(latitude: latitude, longitude: longitude, delta: 0.01)
    }
}

// MARK: - Private Functions

private extension HomeViewController {
    func configureUI() {
        self.navigationItem.title = "메이트 러너"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.right.left.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.bottom.equalTo(self.view.snp.bottom).offset(-120)
        }
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        
    }
    
    func bindUI() {
        self.startButton.rx.tap
            .bind {
                let runningModeSettingViewController = RunningModeSettingViewController()
                self.navigationController?.pushViewController(runningModeSettingViewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
