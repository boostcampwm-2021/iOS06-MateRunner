//
//  SingleRunningResultViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit

import RxCocoa
import RxSwift

final class SingleRunningResultViewController: RunningResultViewController {
    var viewModel: SingleRunningResultViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.bindMapConfiguration(with: output)
        self.bindLabels(with: output)
        self.bindAlert(with: output)
    }
    
    func bindMapConfiguration(with viewModelOutput: SingleRunningResultViewModel.Output) {
        self.drawLine(with: viewModelOutput.points)
        self.configureMapViewLocation(from: viewModelOutput.region)
    }
    
    func bindLabels(with viewModelOutput: SingleRunningResultViewModel.Output) {
        self.dateTimeLabel.text = viewModelOutput.dateTime
        self.korDateTimeLabel.text = viewModelOutput.dayOfWeekAndTime
        self.runningModeLabel.text = viewModelOutput.headerText
        self.distanceLabel.text = viewModelOutput.distance
        self.timeLabel.text = viewModelOutput.time
        self.calorieLabel.text = viewModelOutput.calorie
    }
    
    func bindAlert(with viewModelOutput: SingleRunningResultViewModel.Output) {
        viewModelOutput.saveFailAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: self.disposeBag)
    }
}
