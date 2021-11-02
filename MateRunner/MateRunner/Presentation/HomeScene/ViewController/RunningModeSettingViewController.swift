//
//  RunningModeSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/02.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class RunningModeSettingViewController: UIViewController {
    var viewModel = RunningModeSettingViewModel()
    var disposeBag = DisposeBag()
    
    private lazy var singleButton = createButton("🏃‍♂️ \n 혼자 달리기")
    private lazy var mateButton = createButton("🏃‍♂️🏃‍♀️ \n같이 달리기")
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(singleButton)
        stackView.addArrangedSubview(mateButton)
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 20, family: .regular)
        label.text = "달리기를 선택해주세요"
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = RoundedButton(title: "다음")
        button.backgroundColor = .mrGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
        self.bindViewModel()
    }
}

private extension RunningModeSettingViewController {
    func configureUI() {
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.view.addSubview(self.descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.stackView.snp.top).offset(-70)
        }
        
        singleButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(190)
        }
        
        mateButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(190)
        }
        
        self.view.addSubview(self.nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func createButton(_ title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.notoSans(size: 16, family: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        return button
    }
    
    func bindUI() {
        self.nextButton.rx.tap
            .bind { [weak self]  in
                self?.nextButtonDidTap()
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let input = RunningModeSettingViewModel.Input(
            singleButtonTapEvent: self.singleButton.rx.tap.asDriver(),
            mateButtonTapEvent: self.mateButton.rx.tap.asDriver()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.$runningMode
            .asDriver(onErrorJustReturn: .single)
            .filter { $0 != nil}
            .do {self.changeButtonUI($0 ?? .single)}
            .drive()
            .disposed(by: disposeBag)
    }
    
    func changeButtonUI(_ mode: RunningMode) {
        self.singleButton.backgroundColor = .white
        self.mateButton.backgroundColor = .white
        let modeButton = (mode == .single) ? self.singleButton : self.mateButton
        modeButton.backgroundColor = .mrYellow
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = .mrPurple
    }
    
    func nextButtonDidTap() {
        let mateRunningModeSettingViewController = MateRunningModeSettingViewController()
        self.navigationController?.pushViewController(mateRunningModeSettingViewController, animated: true)
    }
}
