//
//  MapViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/06.
//

import MapKit
import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit

final class MapViewController: UIViewController {
    weak var backButtonDelegate: BackButtonDelegate?
    var viewModel: MapViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var locateButton = createCircleButton(imageName: "location")
    private lazy var backButton = createCircleButton(imageName: "xmark")
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.addGestureRecognizer(UIPanGestureRecognizer())
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
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
    
    func bindViewModel() {
        let input = MapViewModel.Input(
            viewDidAppearEvent: self.rx.methodInvoked(#selector(viewDidAppear(_:)))
                .map({ _ in })
                .asObservable(),
            locateButtonDidTapEvent: self.locateButton.rx.tap.asObservable(),
            backButtonDidTapEvent: self.backButton.rx.tap.asObservable(),
            mapDidPanEvent: self.mapView.rx.panGesture()
                .when(.recognized)
                .map({ _ in })
                .asObservable()
        )
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
        
        output.shouldSetCenter
            .asDriver(onErrorJustReturn: false)
            .filter({ $0 == true })
            .drive(onNext: { [weak self] _ in
                self?.configureCenter()
            })
            .disposed(by: disposeBag)
        
        output.shouldMoveToFirstPage
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] _ in
                self?.backButtonDelegate?.backButtonDidTap()
            })
            .disposed(by: self.disposeBag)
        
        output.coordinatesToDraw
            .asDriver(onErrorJustReturn: (
                self.mapView.userLocation.coordinate,
                self.mapView.userLocation.coordinate)
            )
            .drive(onNext: { [weak self] (previous, current) in
                self?.drawLine(from: previous, to: current)
            })
            .disposed(by: self.disposeBag)
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
    
    func configureCenter() {
        self.mapView.userTrackingMode = .follow
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let locationRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: span)
        self.mapView.setRegion(locationRegion, animated: true)
    }
    
    func drawLine(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let coordinates = [start, end]
        let line = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.addOverlay(line)
    }
}
