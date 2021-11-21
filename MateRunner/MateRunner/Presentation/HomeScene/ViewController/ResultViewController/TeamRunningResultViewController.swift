//
//  TeamRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class TeamRunningResultViewController: RunningResultViewController {
    var viewModel: TeamRunningResultViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var lowerSeparator = self.createSeparator()
    private lazy var totalDistanceLabel = self.createValueLabel()
    private lazy var contributionLabel = self.createValueLabel()
    private lazy var emojiButton = self.createEmojiButton()
    private lazy var reactionView = self.createReactionView()

    private lazy var teamResultView = TeamResultView(
        totalDistanceLabel: self.totalDistanceLabel,
        contributionLabel: self.contributionLabel
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
        self.bindViewModel()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.lowerSeparator)
        self.contentView.addSubview(self.teamResultView)
        self.contentView.addSubview(self.reactionView)
        self.contentView.addSubview(self.mapView)
    }
    
    func configureUI() {
        self.configureLowerSeparator()
        self.configureTeamResultView()
        self.configureReactionView()
        self.configureMapView(with: self.reactionView)
    }
}

// MARK: - Private Functions

private extension TeamRunningResultViewController {
    func bindViewModel() {
        guard let output = self.viewModel?.transform(
            from: TeamRunningResultViewModel.Input(
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
    
    func bindLabels(with viewModelOutput: TeamRunningResultViewModel.Output) {
        self.dateTimeLabel.text = viewModelOutput.dateTime
        self.korDateTimeLabel.text = viewModelOutput.dayOfWeekAndTime
        self.runningModeLabel.text = viewModelOutput.headerText
        self.distanceLabel.text = viewModelOutput.userDistance
        self.timeLabel.text = viewModelOutput.time
        self.calorieLabel.text = viewModelOutput.calorie
        self.totalDistanceLabel.text = viewModelOutput.totalDistance
        self.contributionLabel.text = viewModelOutput.contributionRate
    }
    
    func bindMapConfiguration(with viewModelOutput: TeamRunningResultViewModel.Output) {
        self.drawLine(with: viewModelOutput.points)
        self.configureMapViewLocation(from: viewModelOutput.region)
    }
    
    func configureLowerSeparator() {
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureTeamResultView() {
        self.teamResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
    
    func configureReactionView() {
        self.reactionView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.teamResultView.snp.bottom).offset(20)
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
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        return button
    }
    
    func createReactionView() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 24, family: .medium)
        titleLabel.text = "메이트를 칭찬해주세요!"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = 15
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(self.emojiButton)
        
        return stackView
    }
}
