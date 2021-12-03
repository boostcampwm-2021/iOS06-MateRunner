//
//  RunningProgressView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

final class RunningProgressView: UIProgressView {
    convenience init(width: CGFloat, color: UIColor = .mrPurple) {
        self.init(frame: .zero)
        self.configureUI(width: width, color: color)
    }
}

// MARK: - Private Functions

private extension RunningProgressView {
    func configureUI(width: CGFloat, color: UIColor) {
        self.progressTintColor = color
        self.trackTintColor = .white
        self.setProgress(0.5, animated: false)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(5)
        }
    }
}
