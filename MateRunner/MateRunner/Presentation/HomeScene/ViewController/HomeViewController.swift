//
//  HomeViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit
import CoreLocation
import MapKit

import RxCocoa
import RxSwift
import SnapKit

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
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.colors = [
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0.5).cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.locations = [0, 0.4, 0.7, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return layer
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isZoomEnabled = false
        map.isScrollEnabled = false
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
        self.bindUI()
        self.getLocationUsagePermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.mapView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        case .notDetermined:
            self.getLocationUsagePermission()
        case .denied, .restricted:
            self.setAuthAlertAction()
        default:
            break
        }
    }
    
    func myLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double) {
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        self.mapView.setRegion(locationRegion, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude
        myLocation(latitude: latitude, longitude: longitude, delta: 0.01)
    }
}

// MARK: - Private Functions

private extension HomeViewController {
    func configureUI() {
        self.navigationItem.title = "메이트 러너 🏃🏻‍♀️🏃‍♂️"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        
        self.view.addSubview(self.mapView)
        self.mapView.layer.addSublayer(self.gradientLayer)
        self.mapView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.right.left.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
        }
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        
    }
    
    func bindUI() {
        self.startButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.startButtonDidTap()
            })
            .disposed(by: self.disposeBag)
    }
    
    func startButtonDidTap() {
        let runningModeSettingViewController = RunningModeSettingViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(runningModeSettingViewController, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func setAuthAlertAction() {
        let authAlertController: UIAlertController
        authAlertController = UIAlertController(title: "위치정보 권한 요청",
                                                message: "더 많은 기능을 위해서 위치정보 권한이 필요해요!",
                                                preferredStyle: UIAlertController.Style.alert)
        
        let getAuthAction: UIAlertAction
        getAuthAction = UIAlertAction(title: "네 허용하겠습니다",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        authAlertController.addAction(getAuthAction)
        self.present(authAlertController, animated: true, completion: nil)
    }
}
