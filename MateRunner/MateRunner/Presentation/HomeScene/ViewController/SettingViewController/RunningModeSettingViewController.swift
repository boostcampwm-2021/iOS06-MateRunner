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
    var viewModel: RunningModeSettingViewModel?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension RunningModeSettingViewController {
    func configureUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .systemBackground
        
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
    
    func bindViewModel() {
        let input = RunningModeSettingViewModel.Input(
            singleButtonTapEvent: self.singleButton.rx.tap.asObservable(),
            mateButtonTapEvent: self.mateButton.rx.tap.asObservable()
        )
        let output = self.viewModel?.transform(
            from: input,
            disposeBag: self.disposeBag
        )
        output?.runningMode
            .asDriver(onErrorJustReturn: .single)
            .drive(onNext: { [weak self] mode in
                self?.fillButton(of: mode)
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureButton() {
        self.singleButton.backgroundColor = .white
        self.mateButton.backgroundColor = .white
    }
    
    func fillButton(of mode: RunningMode?) {
        guard let mode = mode else { return }
        mode == .single
        ? (self.singleButton.backgroundColor = .mrYellow)
        : (self.mateButton.backgroundColor = .mrYellow)
    }
}
