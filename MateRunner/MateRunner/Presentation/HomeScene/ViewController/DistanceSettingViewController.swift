//
//  DistanceSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/01.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class DistanceSettingViewController: UIViewController {
    var viewModel = DistanceSettingViewModel()
    var disposeBag = DisposeBag()

    private lazy var distanceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.notoSans(size: 80, family: .black)
        textField.text = "5.00"
        textField.keyboardType = .decimalPad
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
}

private extension DistanceSettingViewController {
    func bindUI() {
        
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.distanceTextField)
        self.distanceTextField.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
