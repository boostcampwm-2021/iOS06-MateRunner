//
//  CancelRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class CancelRunningResultViewController: RunningResultViewController {
    private lazy var lowerSeparator = self.createSeparator()
    
    private lazy var cancelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .medium)
        label.numberOfLines = 2
        label.text = "메이트와의 달리기가\n취소되었습니다 😭"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.lowerSeparator)
        self.contentView.addSubview(self.cancelTitleLabel)
        self.contentView.addSubview(self.mapView)
    }
}

private extension CancelRunningResultViewController {
    func configureUI() {
        self.configureLowerSeparator()
        self.configureTitleLabel()
        self.configureMapView(with: self.cancelTitleLabel)
    }
    
    func configureLowerSeparator() {
        self.contentView.addSubview(self.lowerSeparator)
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureTitleLabel() {
        self.contentView.addSubview(self.cancelTitleLabel)
        self.cancelTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
}
