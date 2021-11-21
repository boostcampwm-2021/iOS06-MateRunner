//
//  RaceRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class RaceRunningResultViewController: RunningResultViewController {
    var viewModel: RaceRunningResultViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var lowerSeparator = self.createSeparator()
    private lazy var raceResultView = RaceResultView()
    private lazy var emojiButton = self.createEmojiButton()
    private lazy var reactionView = self.createReactionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
        self.bindViewModel()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.lowerSeparator)
        self.contentView.addSubview(self.raceResultView)
        self.contentView.addSubview(self.reactionView)
        self.contentView.addSubview(self.mapView)
    }
    
    func configureUI() {
        self.configureLowerSeparator()
        self.configureRaceResultView()
        self.configureReactionView()
        self.configureMapView(with: self.reactionView)
    }
}

private extension RaceRunningResultViewController {
    func bindViewModel() {
        guard let output = self.viewModel?.transform(
            from: RaceRunningResultViewModel.Input(
                viewDidLoadEvent: Observable<Void>.just(()).asObservable(),
                closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable(),
                emojiButtonDidTapEvent: self.emojiButton.rx.tap.asObservable()
            ),
            disposeBag: self.disposeBag
        ) else { return }
        
        self.bindLabels(with: output)
        self.bindMapConfiguration(with: output)
        
        output.selectedEmoji
            .asDriver(onErrorJustReturn: "→")
            .debug()
            .drive(onNext: { selectedEmoji in
                self.emojiButton.setTitle(selectedEmoji, for: .normal)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindLabels(with viewModelOutput: RaceRunningResultViewModel.Output) {
        self.dateTimeLabel.text = viewModelOutput.dateTime
        self.korDateTimeLabel.text = viewModelOutput.dayOfWeekAndTime
        self.runningModeLabel.text = viewModelOutput.headerText
        self.distanceLabel.text = viewModelOutput.distance
        self.timeLabel.text = viewModelOutput.time
        self.calorieLabel.text = viewModelOutput.calorie
        self.raceResultView.updateMateResult(with: viewModelOutput.mateResultValue)
        self.raceResultView.updateTitle(with: viewModelOutput.winnerText)
        self.raceResultView.updateMateResultDescription(with: viewModelOutput.mateResultDescription)
        self.raceResultView.toggleUnitLabel(shouldDisplay: viewModelOutput.unitLabelShouldShow)
    }
    
    func bindMapConfiguration(with viewModelOutput: RaceRunningResultViewModel.Output) {
        self.drawLine(with: viewModelOutput.points)
        self.configureMapViewLocation(from: viewModelOutput.region)
    }
    
    func configureLowerSeparator() {
        self.contentView.addSubview(self.lowerSeparator)
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureRaceResultView() {
        self.contentView.addSubview(self.raceResultView)
        self.raceResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
    
    func configureReactionView() {
        self.contentView.addSubview(self.reactionView)
        self.reactionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.raceResultView.snp.bottom).offset(20)
        }
    }
    
    func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .black)
        return label
    }
    
    func createEmojiButton() -> UIButton {
        let button = UIButton()
        button.setTitle("→", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .notoSans(size: 20, family: .medium)
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.snp.makeConstraints { make in
            make.width.height.equalTo(38)
        }
        return button
    }
    
    func createReactionView() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 24, family: .medium)
        titleLabel.text = "메이트를 칭찬해주세요!"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(self.emojiButton)
        
        return stackView
    }
}
