//
//  RaceRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/09.
//

import UIKit

import SnapKit

final class RaceRunningViewController: SingleRunningViewController {
    private lazy var mateDistanceLabel = self.createDistanceLabel()
    private lazy var mateProgressView = self.createProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // 임시 text, binding 후 제거해야 함
        self.mateDistanceLabel.text = "5.00"
        
        let myCardView = RunningCardView(
            distanceLabel: self.distanceLabel,
            progressView: self.progressView
        )
        myCardView.updateColor(isWinning: true)
        
        let mateCardView = RunningCardView(
            distanceLabel: self.mateDistanceLabel,
            progressView: self.mateProgressView
        )
        mateCardView.updateColor(isWinning: false)
        
        stackView.addArrangedSubview(myCardView)
        stackView.addArrangedSubview(mateCardView)
        return stackView
    }
}
