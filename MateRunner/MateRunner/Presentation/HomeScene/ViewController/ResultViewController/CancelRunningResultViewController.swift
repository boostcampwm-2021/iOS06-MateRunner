//
//  CancelRunningResultViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/10.
//

import UIKit

final class CancelRunningResultViewController: RunningResultViewController {
    private lazy var lowerSeparator = self.createSeparator()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .medium)
        label.numberOfLines = 2
        label.text = "메이트와의 달리기가\n취소되었습니다 😭"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureDifferentSection() {
        self.configureLowerSeparator()
        self.configureTitleLabel()
        self.configureMapView()
    }
    
    override func configureMapView() {
        self.contentView.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}

private extension CancelRunningResultViewController {
    func configureLowerSeparator() {
        self.contentView.addSubview(self.lowerSeparator)
        self.lowerSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
        }
    }
    
    func configureTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.lowerSeparator.snp.bottom).offset(15)
        }
    }
}
