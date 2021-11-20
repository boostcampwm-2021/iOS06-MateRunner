//
//  SingleRunningResultViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/01.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift

final class SingleRunningResultViewController: RunningResultViewController {
    var viewModel: SingleRunningResultViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMap()
        self.configureMapView(with: self.myResultView)
        self.bindViewModel()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.mapView)
    }
}

// MARK: - Private Functions

private extension SingleRunningResultViewController {
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        let input = SingleRunningResultViewModel.Input(
            viewDidLoadEvent: Observable<Void>.just(()).asObservable(),
            closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input, disposeBag: self.disposeBag)
        
        self.bindMap(with: output)
        self.bindLabels(with: output)
        self.bindAlert(with: output)
    }
    
    func bindAlert(with viewModelOutput: SingleRunningResultViewModel.Output) {
        viewModelOutput.saveFailAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindMap(with viewModelOutput: SingleRunningResultViewModel.Output) {
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
    
    func bindLabels(with viewModelOutput: SingleRunningResultViewModel.Output) {
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
