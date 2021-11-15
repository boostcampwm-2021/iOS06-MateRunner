//
//  SignUpViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/13.
//

import UIKit

import RxCocoa
import RxSwift

final class SignUpViewController: UIViewController {
    private var disposeBag = DisposeBag()
    var viewModel: SignUpViewModel?
    
    private lazy var heightTextField = PickerTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
        self.bindUI()
    }
}

// MARK: - Private Functions

private extension SignUpViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.heightTextField)
        self.heightTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = SignUpViewModel.Input(
            heightTextFieldDidTapEvent: self.heightTextField.rx.controlEvent(.touchUpInside).asObservable(),
            heightPickerSelectedRow: self.heightTextField.pickerView.rx.itemSelected.map { $0.row },
            heightDoneButtonDidTapEvent: self.heightTextField.doneButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        output?.$heightRange
            .asDriver()
            .drive(self.heightTextField.pickerView.rx.itemTitles) { (_, element) in
                return element
            }
            .disposed(by: self.disposeBag)
        
        output?.$heightFieldText
            .asDriver()
            .drive(self.heightTextField.rx.text)
            .disposed(by: self.disposeBag)
        
//        output?.$initialHeightPickerRow
//            .asDriver()
//            .drive(onNext: { [weak self] row in
//                self?.heightTextField.pickerView.selectRow(row, inComponent: 0, animated: false)
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func bindUI() {
        self.heightTextField.doneButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.heightTextField.resignFirstResponder()
            })
            .disposed(by: self.disposeBag)
    }
}
