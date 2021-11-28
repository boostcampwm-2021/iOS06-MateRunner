//
//  MyPageViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MyPageViewController: UIViewController {
    var viewModel: MyPageViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "bell"),
            style: .plain,
            target: self,
            action: nil
        )
        return button
    }()
    
    private lazy var profileView: UIView = UIView()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .bold)
        return label
    }()
    
    private lazy var settingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var profileEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .notoSans(size: 13, family: .light)
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 1
        button.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        return button
    }()
    
    private lazy var licenseView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var licenseLabel: UILabel = {
        let label = UILabel()
        label.text = "라이센스"
        label.font = .notoSans(size: 15, family: .regular)
        return label
    }()
    
    private lazy var licenseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.contentHorizontalAlignment = .right
        button.tintColor = .systemGray
        return button
    }()
    
    private lazy var logoutButton: UIButton = self.createSettingButton(title: "로그아웃")
    
    private lazy var withdrawalButton: UIButton = self.createSettingButton(title: "회원탈퇴")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

private extension MyPageViewController {
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        let input = MyPageViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            notificationButtonDidTapEvent: notificationButton.rx.tap.asObservable(),
            profileEditButtonDidTapEvent: profileEditButton.rx.tap.asObservable(),
            licenseButtonDidTapEvent: licenseButton.rx.tap.asObservable(),
            logoutButtonDidTapEvent: logoutButton.rx.tap.asObservable(),
            withdrawalButtonDidTapEvent: withdrawalButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
        self.nicknameLabel.text = output.nickname
        
        output.imageURL
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] imageURL in
                self?.profileImageView.setImage(with: imageURL)
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureUI() {
        self.configureNavigationBar()
        self.configureSubViews()
        self.configureProfileUI()
        self.configureSettingUI()
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = notificationButton
    }
    
    func configureProfileUI() {
        self.profileView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(80)
        }
        
        self.nicknameLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImageView.snp.bottom).offset(20)
        }
        
        self.profileEditButton.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nicknameLabel.snp.bottom).offset(30)
        }
    }
    
    func configureSettingUI() {
        self.settingStackView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.top.equalTo(self.profileView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.licenseView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.licenseLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        self.licenseButton.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.licenseLabel)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        self.logoutButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.withdrawalButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    func configureSubViews() {
        self.view.addSubview(self.profileView)
        self.view.addSubview(self.settingStackView)
        
        self.profileView.addSubview(self.profileImageView)
        self.profileView.addSubview(self.nicknameLabel)
        self.profileView.addSubview(self.profileEditButton)
        
        self.settingStackView.addArrangedSubview(self.createSeparator())
        self.settingStackView.addArrangedSubview(self.licenseView)
        self.licenseView.addSubview(self.licenseLabel)
        self.licenseView.addSubview(self.licenseButton)
        self.settingStackView.addArrangedSubview(self.createSeparator())
        self.settingStackView.addArrangedSubview(self.logoutButton)
        self.settingStackView.addArrangedSubview(self.createSeparator())
        self.settingStackView.addArrangedSubview(self.withdrawalButton)
        self.settingStackView.addArrangedSubview(self.createSeparator())
    }
    
    func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    func createSettingButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .notoSans(size: 15, family: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return button
    }
}
