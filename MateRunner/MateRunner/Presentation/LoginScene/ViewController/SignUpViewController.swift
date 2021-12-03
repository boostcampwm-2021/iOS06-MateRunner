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
    private lazy var weightTextField = PickerTextField()
    private lazy var descriptionLabel = UILabel()
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 이미지 변경하기", for: .normal)
        button.titleLabel?.font = UIFont.notoSans(size: 13, family: .bold)
        button.setTitleColor(UIColor.mrPurple, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 17, family: .light)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "환영해요 🙌\n메이트러너와 함께 달릴 준비를 해주세요!"
        return label
    }()
    
    private lazy var emojiTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.notoSans(size: 60, family: .light)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 40
        textField.sizeToFit()
        return textField
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .asciiCapable
        textField.backgroundColor = .systemGray6
        textField.font = .notoSans(size: 13, family: .regular)
        textField.placeholder = "영문, 숫자만 5~20자 이내로 입력해주세요."
        return textField
    }()
    
    private lazy var nicknameSection = self.createInputSection(
        text: "닉네임",
        textField: self.nicknameTextField,
        isNickname: true
    )
    
    private lazy var heightSection = self.createInputSection(
        text: "키",
        textField: self.heightTextField)
    
    private lazy var weightSection = self.createInputSection(
        text: "몸무게",
        textField: self.weightTextField
    )
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.addArrangedSubview(self.nicknameSection)
        stackView.addArrangedSubview(self.heightSection)
        stackView.addArrangedSubview(self.weightSection)
        return stackView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("준비완료!", for: .normal)
        button.backgroundColor = UIColor.mrPurple
        button.titleLabel?.font = UIFont.notoSans(size: 15, family: .regular)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureUI()
        self.bindViewModel()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Private Functions

private extension SignUpViewController {
    func configureSubviews() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.emojiTextField)
        self.view.addSubview(self.shuffleButton)
        self.view.addSubview(self.inputStackView)
        self.view.addSubview(self.doneButton)
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
        }
        
        self.emojiTextField.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25)
        }
        
        self.shuffleButton.snp.makeConstraints { make in
            make.top.equalTo(self.emojiTextField.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        self.inputStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(60)
            make.top.equalTo(self.shuffleButton.snp.bottom).offset(25)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            make.top.equalTo(self.inputStackView.snp.bottom).offset(50)
        }
        
        self.doneButton.layer.cornerRadius = 40
        self.doneButton.addShadow(offset: CGSize(width: 3, height: 5))
    }
    
    func bindViewModel() {
        let input = SignUpViewModel.Input(
            nicknameTextFieldDidEditEvent: self.nicknameTextField.rx.text.orEmpty.asObservable(),
            shuffleButtonDidTapEvent: self.shuffleButton.rx.tap.asObservable(),
            heightTextFieldDidTapEvent: self.heightTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            heightPickerSelectedRow: self.heightTextField.pickerView.rx.itemSelected.map { $0.row },
            weightTextFieldDidTapEvent: self.weightTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            weightPickerSelectedRow: self.weightTextField.pickerView.rx.itemSelected.map { $0.row },
            doneButtonDidTapEvent: self.doneButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        output?.profileEmoji
            .asDriver()
            .drive(onNext: { [weak self] newEmoji in
                self?.emojiTextField.text = newEmoji
            })
            .disposed(by: disposeBag)
        self.bindNicknameTextField(output: output)
        self.bindDescriptionLabel(output: output)
        self.bindHeightTextField(output: output)
        self.bindWeightTextField(output: output)
        self.bindDoneButton(output: output)
    }
    
    func bindNicknameTextField(output: SignUpViewModel.Output?) {
        output?.nicknameFieldText
            .asDriver()
            .drive(self.nicknameTextField.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindDescriptionLabel(output: SignUpViewModel.Output?) {
        output?.validationErrorMessage
            .asDriver()
            .drive(onNext: { [weak self] message in
                self?.descriptionLabel.text = message
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindHeightTextField(output: SignUpViewModel.Output?) {
        output?.heightRange
            .asDriver()
            .drive(self.heightTextField.pickerView.rx.itemTitles) { (_, element) in
                return element
            }
            .disposed(by: self.disposeBag)
        
        output?.heightFieldText
            .asDriver()
            .drive(self.heightTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.heightPickerRow
            .asDriver()
            .drive(onNext: { [weak self] row in
                guard let row = row else { return }
                self?.heightTextField.pickerView.selectRow(row, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindWeightTextField(output: SignUpViewModel.Output?) {
        output?.weightRange
            .asDriver()
            .drive(self.weightTextField.pickerView.rx.itemTitles) { (_, element) in
                return element
            }
            .disposed(by: self.disposeBag)
        
        output?.weightFieldText
            .asDriver()
            .drive(self.weightTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.weightPickerRow
            .asDriver()
            .drive(onNext: { [weak self] row in
                guard let row = row else { return }
                self?.weightTextField.pickerView.selectRow(row, inComponent: 0, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindDoneButton(output: SignUpViewModel.Output?) {
        output?.doneButtonShouldEnable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                self?.doneButton.isEnabled = isValid
                self?.doneButton.backgroundColor = isValid ? .mrPurple : .lightGray
            })
            .disposed(by: self.disposeBag)
    }
    
    func createInputSection(text: String, textField: UITextField, isNickname: Bool = false) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 15, family: .light)
        titleLabel.text = text
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        
        if isNickname {
            stackView.addArrangedSubview(self.createNicknameLabelStack(titleLabel: titleLabel))
        } else {
            stackView.addArrangedSubview(titleLabel)
        }
        stackView.addArrangedSubview(textField)
        return stackView
    }
    
    func createNicknameLabelStack(titleLabel: UILabel) -> UIStackView {
        self.descriptionLabel.font = .notoSans(size: 10, family: .medium)
        self.descriptionLabel.textColor = .mrPurple
        self.descriptionLabel.textAlignment = .right
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        return stackView
    }
}
