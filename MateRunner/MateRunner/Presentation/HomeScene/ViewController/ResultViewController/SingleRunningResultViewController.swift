//
//  SingleRunningResultViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/01.
//

import CoreLocation
import MapKit
import UIKit

import RxCocoa
import RxSwift

class SingleRunningResultViewController: RunningResultViewController {
    var viewModel: RunningResultViewModel?
    let disposeBag = DisposeBag()
    lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureMap()
        self.bindViewModel()
    }
    
    func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    func configureDifferentSection() {
        self.configureMapView()
    }
    
    func configureMapView() {
        super.contentView.addSubview(self.mapView)
        
        self.mapView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

// MARK: - Private Functions

private extension SingleRunningResultViewController {
    func configureMap() {
        self.mapView.delegate = self
        self.mapView.mapType = .standard
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.configureDifferentSection()
    }
    
    func configureMapViewLocation(from region: Region) {
        let coordinateLocation = region.center
        let spanValue = MKCoordinateSpan(latitudeDelta: region.span.0, longitudeDelta: region.span.1)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        self.mapView.setRegion(locationRegion, animated: true)
    }
    
    func showAlert() {
        let message = "달리기 결과 저장 중 오류가 발생했습니다."
        
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default, handler: { _ in
            self.viewModel?.alertConfirmButtonDidTap()
        })
        alert.addAction(cancel)
        present(alert, animated: false, completion: nil)
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        let input = RunningResultViewModel.Input(
            viewDidLoadEvent: Observable<Void>.just(()).asObservable(),
            closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input, disposeBag: self.disposeBag)
        
        self.bindMap(with: output)
        self.bindLabels(with: output)
        self.bindAlert(with: output)
    }
    
    func bindAlert(with viewModelOutput: RunningResultViewModel.Output) {
        viewModelOutput.saveFailAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindMap(with viewModelOutput: RunningResultViewModel.Output) {
        viewModelOutput.points
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] points in
                let lineDraw = MKPolyline(coordinates: points, count: points.count)
                self?.mapView.addOverlay(lineDraw)
            })
            .disposed(by: self.disposeBag)
        
        viewModelOutput.region
            .asDriver(onErrorJustReturn: Region())
            .drive(onNext: { [weak self] region in
                self?.configureMapViewLocation(from: region)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindLabels(with viewModelOutput: RunningResultViewModel.Output) {
        viewModelOutput.dateTime
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.dateTimeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModelOutput.dayOfWeekAndTime
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.korDateTimeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModelOutput.mode
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.runningModeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModelOutput.distance
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.distanceLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModelOutput.calorie
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.calorieLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        viewModelOutput.time
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.timeLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension SingleRunningResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .mrPurple
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
