//
//  ModeSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/02.
//

import SnapKit
import UIKit

final class ModeSettingViewController: UIViewController {
    private lazy var singleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.notoSans(size: 16, family: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("혼자 달리기", for: .normal)
        button.layer.cornerRadius = 10
        button.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        return button
    }()
    
    private lazy var mateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.notoSans(size: 16, family: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("같이 달리기", for: .normal)
        button.layer.cornerRadius = 10
        button.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(singleButton)
        stackView.addArrangedSubview(mateButton)
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

private extension ModeSettingViewController {
    func configureUI() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        singleButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(190)
        }
        
        mateButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(190)
        }
    }
}

extension UIView {
    enum shadowLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(location: shadowLocation, color: UIColor = .systemGray4, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
