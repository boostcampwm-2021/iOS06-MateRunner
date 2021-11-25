//
//  ProfileEditViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

import RxSwift

final class ProfileEditViewController: UIViewController {
    var viewModel: ProfileEditViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: nil)
    private lazy var imageEditButton = ImageEditButton()
    private lazy var heightTextField = PickerTextField()
    private lazy var weightTextField = PickerTextField()
    private lazy var heightSection = self.createInputSection(text: "키", textField: self.heightTextField)
    private lazy var weightSection = self.createInputSection(text: "몸무게", textField: self.weightTextField)
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "OOO"
        label.font = .notoSans(size: 18, family: .bold)
        return label
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        
        stackView.addArrangedSubview(self.heightSection)
        stackView.addArrangedSubview(self.weightSection)
        return stackView
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

private extension ProfileEditViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.view.addSubview(self.imageEditButton)
        self.imageEditButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(32)
        }
        
        self.view.addSubview(self.nicknameLabel)
        self.nicknameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imageEditButton.snp.bottom).offset(17)
        }
        
        self.view.addSubview(self.inputStackView)
        self.inputStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.nicknameLabel.snp.bottom).offset(30)
        }
    }
    
    func bindUI() {
        self.imageEditButton.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePickerController, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func createInputSection(text: String, textField: UITextField) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .notoSans(size: 18, family: .regular)
        titleLabel.text = text
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        return stackView
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.imageEditButton.profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
