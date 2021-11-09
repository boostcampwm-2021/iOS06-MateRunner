//
//  TeamRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/09.
//

import UIKit

final class TeamRunningViewController: SingleRunningViewController {
    private lazy var totalDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 100)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
    }
    
    override func createDistanceLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 30)
        return label
    }
    
    override func createDistanceStackView() -> UIStackView {
        let myDistanceStackView = self.createMyDistanceStackView()
        let totalDistanceStackView = self.createTotalDistanceStackView()
        
        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.alignment = .trailing
        innerStackView.spacing = -20
        
        innerStackView.addArrangedSubview(myDistanceStackView)
        innerStackView.addArrangedSubview(totalDistanceStackView)
        
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .center
        outerStackView.spacing = 30
        
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.addArrangedSubview(self.progressView)
        return outerStackView
    }
}

// MARK: - Private Functions

private extension TeamRunningViewController {
    func createMyDistanceStackView() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = "내가 뛴 거리"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.spacing = 10
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(self.distanceLabel)
        return stackView
    }
    
    func createTotalDistanceStackView() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = "킬로미터"
        self.totalDistanceLabel.text = "9.99"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = -15
        
        stackView.addArrangedSubview(self.totalDistanceLabel)
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }
}
