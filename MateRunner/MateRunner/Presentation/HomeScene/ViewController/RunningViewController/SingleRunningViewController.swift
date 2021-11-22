//
//  SingleRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//
import UIKit

import RxCocoa
import RxSwift
import RxGesture
import SnapKit

class SingleRunningViewController: RunningViewController {
    var viewModel: SingleRunningViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
}

// MARK: - Private Functions
private extension SingleRunningViewController {
    func bindViewModel() {
        let input = SingleRunningViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            finishButtonLongPressDidBeginEvent: self.cancelButton.rx
                .longPressGesture()
                .when(.began)
                .map({ _ in })
                .asObservable(),
            finishButtonLongPressDidCancelEvent: self.cancelButton.rx
                .longPressGesture()
                .when(.ended, .cancelled, .failed)
                .map({ _ in })
                .asObservable(),
            finishButtonDidTapEvent: self.cancelButton.rx.tap
                .asObservable()
        )
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        self.configureViewModelOutput(output)
    }
    
    func configureViewModelOutput(_ output: SingleRunningViewModel.Output?) {
        output?.timeSpent
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] newValue in
                self?.timeView.updateValue(newValue: newValue)
            })
            .disposed(by: self.disposeBag)
        
        output?.cancelTimeLeft
            .asDriver(onErrorJustReturn: "종료")
            .drive(onNext: { [weak self] newValue in
                self?.updateTimeLeftText(with: newValue)
            })
            .disposed(by: self.disposeBag)
        
        output?.popUpShouldShow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isNeeded in
                self?.toggleCancelFolatingView(isNeeded: isNeeded)
            })
            .disposed(by: disposeBag)
        
        output?.distance
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] distance in
                self?.distanceLabel.text = distance
            })
            .disposed(by: self.disposeBag)
        
        output?.progress
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] progress in
                self?.progressView.setProgress(Float(progress), animated: false)
            })
            .disposed(by: self.disposeBag)
        
        output?.calorie
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] calorie in
                self?.calorieView.updateValue(newValue: calorie)
            })
            .disposed(by: self.disposeBag)
    }
}
