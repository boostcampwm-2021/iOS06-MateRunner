//
//  RecordDetailViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import UIKit

final class RecordDetailViewController: RunningResultViewController {
    var viewModel: RecordDetailViewModel?
    
    private lazy var lowerSeparator = self.createSeparator()
    private lazy var totalDistanceLabel = self.createValueLabel()
    private lazy var contributionLabel = self.createValueLabel()
    private lazy var emojiListView = EmojiListView()
    private var mateResultView: UIStackView?
    
    private lazy var canceledResultLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .medium)
        label.numberOfLines = 2
        label.text = "메이트와의 달리기가\n취소되었습니다 😭"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.emojiListView)
        self.contentView.addSubview(self.mapView)
    }
}

private extension RecordDetailViewController {
    func bindViewModel() {
        guard let output = self.viewModel?.createViewModelOutput(),
              let mode = output.runningMode else { return }
        
        self.configureDifferentSubViews(mode: mode, isCanceled: output.isCanceled)
        self.configureUI(mode: mode, isCanceled: output.isCanceled)
        self.bindMapConfiguration(with: output)
        self.bindLabels(with: output)
        self.bindEmojiListView(with: output.emojiList)
    }
    
    func configureDifferentSubViews(mode: RunningMode, isCanceled: Bool) {
        guard mode != .single else { return }
        
        self.contentView.addSubview(self.lowerSeparator)
        if isCanceled {
            self.contentView.addSubview(self.canceledResultLabel)
        } else {
            self.mateResultView = (mode == .race) ? RaceResultView() : TeamResultView(
                totalDistanceLabel: self.totalDistanceLabel,
                contributionLabel: self.contributionLabel
            )
            
            if let mateResultView = self.mateResultView {
                self.contentView.addSubview(mateResultView)
            }
        }
    }
    
    func configureUI(mode: RunningMode, isCanceled: Bool) {
        self.closeButton.isHidden = true
        
        if mode == .single {
            self.configureEmojiListView(with: self.myResultView)
            self.configureMapView(with: self.emojiListView)
            return
        }
        
        self.configureLowerSeparator()
        if isCanceled {
            self.configureCanceledResultView()
            self.configureEmojiListView(with: self.canceledResultLabel)
        } else {
            self.configureMateResultView()
            self.configureEmojiListView(with: self.mateResultView)
        }
        
        self.configureMapView(with: self.emojiListView)
    }
    
    func bindMapConfiguration(with viewModelOutput: RecordDetailViewModel.Output) {
        self.drawLine(with: viewModelOutput.points)
        self.configureMapViewLocation(from: viewModelOutput.region)
    }
    
    func bindLabels(with viewModelOutput: RecordDetailViewModel.Output) {
        self.dateTimeLabel.text = viewModelOutput.dateTime
        self.korDateTimeLabel.text = viewModelOutput.dayOfWeekAndTime
        self.runningModeLabel.text = viewModelOutput.headerText
        self.distanceLabel.text = viewModelOutput.distance
        self.timeLabel.text = viewModelOutput.time
        self.calorieLabel.text = viewModelOutput.calorie
        
        if let raceResultView = mateResultView as? RaceResultView {
            raceResultView.updateMateResult(with: viewModelOutput.mateResultValue)
            raceResultView.updateTitle(with: viewModelOutput.winnerText)
            raceResultView.updateMateResultDescription(with: viewModelOutput.mateResultDescription)
            raceResultView.toggleUnitLabel(shouldDisplay: viewModelOutput.unitLabelShouldShow ?? false)
        } else if mateResultView is TeamResultView {
            self.totalDistanceLabel.text = viewModelOutput.totalDistance
            self.contributionLabel.text = viewModelOutput.contributionRate
        }
    }
    
    func bindEmojiListView(with emojiList: [String: String]?) {
        guard let emojiList = emojiList else {
            self.emojiListView.isHidden = true
            return
        }
        self.emojiListView.bindUI(emojiList: emojiList)
    }
    
    func configureLowerSeparator() {
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureCanceledResultView() {
        self.canceledResultLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
    
    func configureMateResultView() {
        self.mateResultView?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        })
    }
    
    func configureEmojiListView(with upperView: UIView?) {
        guard let upperView = upperView else { return }
        self.emojiListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(upperView.snp.bottom).offset(15)
        }
    }
    
    func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .black)
        return label
    }
}
