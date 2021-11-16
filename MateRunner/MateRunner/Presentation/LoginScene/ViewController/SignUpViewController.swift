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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 25, family: .bold)
        label.text = "회원가입"
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.font = .notoSans(size: 16, family: .regular)
        return textField
    }()
    
    private lazy var heightTextField = PickerTextField()
    private lazy var weightTextField = PickerTextField()
    
    private lazy var nicknameSection = self.createInputSection(
        text: "닉네임",
        textField: self.nicknameTextField,
        isNickname: true
    )
    
    private lazy var heightSection = self.createInputSection(text: "키", textField: self.heightTextField)
    private lazy var weightSection = self.createInputSection(text: "몸무게", textField: self.weightTextField)
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.addArrangedSubview(self.nicknameSection)
        stackView.addArrangedSubview(self.heightSection)
        stackView.addArrangedSubview(self.weightSection)
        return stackView
    }()
    
    private lazy var doneButton = RoundedButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Private Functions

private extension SignUpViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(self.inputStackView)
        self.inputStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }
        
        self.view.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func bindViewModel() {
        let input = SignUpViewModel.Input(
            nickname: self.nicknameTextField.rx.text.orEmpty.asObservable(),
            heightTextFieldDidTapEvent: self.heightTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            heightPickerSelectedRow: self.heightTextField.pickerView.rx.itemSelected.map { $0.row },
            weightTextFieldDidTapEvent: self.weightTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            weightPickerSelectedRow: self.weightTextField.pickerView.rx.itemSelected.map { $0.row }
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        self.bindNicknameTextField(output: output)
        self.bindHeightTextField(output: output)
        self.bindWeightTextField(output: output)
        self.bindDoneButton(output: output)
    }
    
    func bindNicknameTextField(output: SignUpViewModel.Output?) {
        output?.$nicknameFieldText
            .asDriver()
            .drive(self.nicknameTextField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindHeightTextField(output: SignUpViewModel.Output?) {
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
        
        output?.$heightPickerRow
            .asDriver()
            .drive(onNext: { [weak self] row in
                self?.heightTextField.pickerView.selectRow(row, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindWeightTextField(output: SignUpViewModel.Output?) {
        output?.$weightRange
            .asDriver()
            .drive(self.weightTextField.pickerView.rx.itemTitles) { (_, element) in
                return element
            }
            .disposed(by: self.disposeBag)
        
        output?.$weightFieldText
            .asDriver()
            .drive(self.weightTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.$weightPickerRow
            .asDriver()
            .drive(onNext: { [weak self] row in
                self?.weightTextField.pickerView.selectRow(row, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindDoneButton(output: SignUpViewModel.Output?) {
        output?.$isNicknameValid
            .asDriver()
            .drive(onNext: { [weak self] isValid in
                self?.doneButton.isEnabled = isValid
                self?.doneButton.backgroundColor = isValid ? .mrPurple : .lightGray
            })
            .disposed(by: self.disposeBag)
    }
    
    func createInputSection(text: String, textField: UITextField, isNickname: Bool = false) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 20, family: .bold)
        titleLabel.text = text
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        
        if isNickname {
            stackView.addArrangedSubview(self.createNicknameLabelStack(titleLabel: titleLabel))
        } else {
            stackView.addArrangedSubview(titleLabel)
        }
        stackView.addArrangedSubview(textField)
        return stackView
    }
    
    func createNicknameLabelStack(titleLabel: UILabel) -> UIStackView {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .notoSans(size: 14, family: .regular)
        descriptionLabel.text = "5~20자의 영문, 숫자 조합"

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .lastBaseline
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        return stackView
    }
}
