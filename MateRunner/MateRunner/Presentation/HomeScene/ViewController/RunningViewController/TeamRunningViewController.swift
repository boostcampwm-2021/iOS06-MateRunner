//
//  TeamRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import SnapKit

final class TeamRunningViewController: RunningViewController {
    var viewModel: TeamRunningViewModel?
    
    private lazy var totalDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 100)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    override func createDistanceLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 30)
        return label
    }
    
    override func createDistanceStackView() -> UIStackView {
        let myDistanceStackView = self.createMyDistanceStackView()
        let totalDistanceStackView = self.createTotalDistanceStackView()
        
        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.alignment = .trailing
        innerStackView.spacing = -20
        
        innerStackView.addArrangedSubview(myDistanceStackView)
        innerStackView.addArrangedSubview(totalDistanceStackView)
        
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .center
        outerStackView.spacing = 30
        
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.addArrangedSubview(self.progressView)
        return outerStackView
    }
}

// MARK: - Private Functions

private extension TeamRunningViewController {
    func createMyDistanceStackView() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = "내가 뛴 거리"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.spacing = 10
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(self.distanceLabel)
        return stackView
    }
    
    func createTotalDistanceStackView() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = "킬로미터"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = -15
        
        stackView.addArrangedSubview(self.totalDistanceLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }
    
    func bindViewModel() {
        let input = TeamRunningViewModel.Input(
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
    
    func configureViewModelOutput(_ output: TeamRunningViewModel.Output?) {
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
        
        output?.totalDistance
            .asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [weak self] distance in
                self?.totalDistanceLabel.text = distance
            })
            .disposed(by: self.disposeBag)
        
        output?.totalProgress
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
