//
//  RaceRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import SnapKit

final class RaceRunningViewController: RunningViewController {
    var viewModel: RaceRunningViewModel?
    
    private lazy var mateDistanceLabel = self.createDistanceLabel()
    private lazy var mateProgressView = self.createProgressView()
    
    private lazy var myCardView = RunningCardView(
        distanceLabel: self.distanceLabel,
        progressView: self.progressView
    )
    
    private lazy var mateCardView = RunningCardView(
        distanceLabel: self.mateDistanceLabel,
        progressView: self.mateProgressView
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    override func createDistanceLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 50)
        return label
    }
    
    override func createProgressView() -> UIProgressView {
        return RunningProgressView(width: 160)
    }
    
    override func createDistanceStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.addArrangedSubview(myCardView)
        stackView.addArrangedSubview(mateCardView)
        myCardView.updateColor(isWinning: false)
        mateCardView.updateColor(isWinning: false)
        return stackView
    }
}

private extension RaceRunningViewController {
    func bindViewModel() {
        let input = RaceRunningViewModel.Input(
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
    
    func configureViewModelOutput(_ output: RaceRunningViewModel.Output?) {
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
        
        output?.myDistance
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] distance in
                self?.distanceLabel.text = distance
            })
            .disposed(by: self.disposeBag)
        
        output?.mateDistance
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] distance in
                self?.mateDistanceLabel.text = distance
            })
            .disposed(by: self.disposeBag)
        
        Driver.zip(
            output?.myDistance.asDriver(onErrorJustReturn: "0.0") ?? Driver.just("0.0"),
            output?.mateDistance.asDriver(onErrorJustReturn: "0.0") ?? Driver.just("0.0")
        ).asDriver(onErrorJustReturn: ("0.0", "0.0"))
            .drive { [weak self] myDistance, mateDistance in
                guard let self = self,
                      let myDistance = Double(myDistance),
                      let mateDistance = Double(mateDistance) else { return }
                self.myCardView.updateColor(isWinning: myDistance > mateDistance)
                self.mateCardView.updateColor(isWinning: myDistance < mateDistance)
            }
            .disposed(by: self.disposeBag)
        
        output?.myProgress
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] progress in
                self?.progressView.setProgress(Float(progress), animated: false)
            })
            .disposed(by: self.disposeBag)
        
        output?.mateProgress
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] progress in
                self?.mateProgressView.setProgress(Float(progress), animated: false)
            })
            .disposed(by: self.disposeBag)
        
        output?.calorie
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] calorie in
                self?.calorieView.updateValue(newValue: calorie)
            })
            .disposed(by: self.disposeBag)
        
        output?.cancelledAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.showAlert(message: "메이트가 달리기를 중도 취소했습니다.")
            })
            .disposed(by: self.disposeBag)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}
