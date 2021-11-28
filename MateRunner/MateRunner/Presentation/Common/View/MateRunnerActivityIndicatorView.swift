//
//  MateRunnerActivityIndicatorView.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/27.
//

import UIKit

final class MateRunnerActivityIndicatorView: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(color: UIColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        self.color = color
        self.hidesWhenStopped = true
        self.style = .large
        self.startAnimating()
    }
}
