//
//  DistanceSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/01.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DistanceSettingViewController: UIViewController {
    var viewModel: DistanceSettingViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "  "
        button.tintColor = .label
        return button
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .notoSans(size: 16, family: .regular)
        label.text = "거리를 설정해주세요"
        return label
    }()
    
    private lazy var kilometerLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 16, family: .regular)
        label.text = "킬로미터"
        return label
    }()
    
    private lazy var startButton = RoundedButton(title: "달리기 시작")

    private lazy var distanceTextField: CursorDisabledTextField = {
        let textField = CursorDisabledTextField()
        textField.borderStyle = .none
        textField.font = .notoSansBoldItalic(size: 100)
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSAttributedString(string: "5.00", attributes: attributes)
        textField.attributedText = attributedString
        textField.keyboardType = .decimalPad
		textField.tintColor = .clear
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension DistanceSettingViewController {
    func bindUI() {
        self.distanceTextField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.doneButton.title = "설정"
            }).disposed(by: self.disposeBag)
        
        self.doneButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.view.endEditing(true)
                self?.doneButton.title = ""
            }).disposed(by: self.disposeBag)
        
        self.startButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.startButtonDidTap()
            }).disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let input = DistanceSettingViewModel.Input(
            distance: self.distanceTextField.rx.text.orEmpty.asObservable(),
            doneButtonTapEvent: self.doneButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        output?.$distanceFieldText
            .asDriver()
            .drive(self.distanceTextField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "목표 거리"
        self.navigationItem.rightBarButtonItem = self.doneButton
        self.view.addSubview(self.noticeLabel)
        self.noticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
        }
        self.view.addSubview(self.distanceTextField)
        self.distanceTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.noticeLabel.snp.bottom).offset(20)
        }
        self.view.addSubview(self.kilometerLabel)
        self.kilometerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.distanceTextField.snp.bottom).offset(20)
        }
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func startButtonDidTap() {
        let runningPreparationViewController = RunningPreparationViewController()
        self.navigationController?.pushViewController(runningPreparationViewController, animated: true)
    }
}
