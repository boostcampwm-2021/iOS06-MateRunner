//
//  MapViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/06.
//

import UIKit
import CoreLocation
import MapKit

import RxCocoa
import RxSwift
import SnapKit

class MapViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var previousCoordinate: CLLocationCoordinate2D?
    private var shouldSetCenter = true
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.delegate = self
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(panGestureRecognizer)
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }()
    
    private lazy var locateButton = createCircleButton(imageName: "location")
    private lazy var backButton = createCircleButton(imageName: "xmark")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
        self.configureLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        
        if shouldSetCenter {
            self.mapView.userTrackingMode = .follow
        }
        
        if let previousCoordinate = self.previousCoordinate {
            let coordinates = [previousCoordinate, coordinate]
            let line = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(line)
        }
        
        self.previousCoordinate = coordinate
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }

        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .mrPurple
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0

        return renderer
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

// MARK: - Private Functions

private extension MapViewController {
    func configureUI() {
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.locateButton)
        self.locateButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(50)
        }
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    func bindUI() {
        self.locateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.locateButtonDidTap()
            }).disposed(by: self.disposeBag)
        
        if let panGestureRecognizer = self.mapView.gestureRecognizers?.first {
            panGestureRecognizer.rx.event
                .asDriver()
                .drive(onNext: { [weak self] gestureRecognizer in
                    self?.panGestureDidRecognize(gestureRecognizer)
                }).disposed(by: self.disposeBag)
        }
    }
    
    func configureLocationManager() {
        self.locationManager.startUpdatingLocation()
    }
    
    func configureCurrentLocation() {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let locationRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: span)
        self.mapView.setRegion(locationRegion, animated: true)
    }
    
    func createCircleButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.backgroundColor = .mrPurple
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        return button
    }
    
    func locateButtonDidTap() {
        self.configureCurrentLocation()
        self.shouldSetCenter = true
    }
    
    func panGestureDidRecognize(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            self.shouldSetCenter = false
        }
    }
}
