//
//  RunningCardView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/09.
//

import UIKit

import RxSwift

final class RunningCardView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        return imageView
    }()
    
    convenience init(distanceLabel: UILabel, progressView: UIProgressView) {
        self.init(frame: .zero)
        self.configureUI(distanceLabel: distanceLabel, progressView: progressView)
        self.updateColor(isWinning: false)
    }
    
    func updateColor(isWinning: Bool) {
        guard let labelStackView = self.subviews.first?.subviews.last?.subviews.first as? UIStackView,
              let progressView = self.subviews.first?.subviews.last?.subviews.last as? UIProgressView else { return }
        
        labelStackView.arrangedSubviews.forEach { subView in
            guard let label = subView as? UILabel else { return }
            label.textColor = isWinning ? .white: .black
        }
        
        progressView.progressTintColor = isWinning ? .mrYellow : .mrPurple
        self.backgroundColor = isWinning ? .mrPurple : .systemGray5
    }
    
    func updateProfileImage(with imageURL: String) {
        self.profileImageView.setImage(with: imageURL, disposeBag: self.disposeBag)
    }
}

// MARK: - Private Functions

private extension RunningCardView {
    func configureUI(distanceLabel: UILabel, progressView: UIProgressView) {
        let infoStackView = self.createInfoStackView(distanceLabel: distanceLabel, progressView: progressView)
        
        self.layer.cornerRadius = 15
        self.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.left.top.equalTo(infoStackView).offset(-15)
            make.right.bottom.equalTo(infoStackView).offset(15)
        }
    }
    
    func createInfoStackView(distanceLabel: UILabel, progressView: UIProgressView) -> UIStackView {
        let labelStackView = self.createLabelStackView(distanceLabel: distanceLabel)
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        
        verticalStackView.addArrangedSubview(labelStackView)
        verticalStackView.addArrangedSubview(progressView)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 25
        
        horizontalStackView.addArrangedSubview(self.profileImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        return horizontalStackView
    }
    
    func createLabelStackView(distanceLabel: UILabel) -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSansBoldItalic(size: 20)
        nameLabel.text = "KM"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.spacing = 10
        
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }
}
