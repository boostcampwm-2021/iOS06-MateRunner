//
//  MateRunningModeSettingViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/01.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit

final class MateRunningModeSettingViewController: UIViewController {
    var viewModel: MateRunningModeSettingViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 25, family: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 14, family: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var raceModeButton = createModeButton(emoji: "🤜", title: RunningMode.race.title)
    private lazy var teamModeButton = createModeButton(emoji: "🤝", title: RunningMode.team.title)
    private lazy var nextButton = RoundedButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension MateRunningModeSettingViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "달리기 모드"
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.height.equalTo(45)
        }
        self.view.addSubview(self.raceModeButton)
        self.raceModeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(30)
            make.height.equalTo(80)
        }
        self.view.addSubview(self.teamModeButton)
        self.teamModeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.raceModeButton.snp.bottom).offset(20)
            make.height.equalTo(80)
        }
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func bindViewModel() {
        let input = MateRunningModeSettingViewModel.Input(
            raceModeButtonDidTapEvent: raceModeButton.rx.tapGesture()
                .when(.recognized)
                .map({_ in })
                .asObservable(),
            teamModeButtonDidTapEvent: teamModeButton.rx.tapGesture()
                .when(.recognized)
                .map({_ in })
                .asObservable(),
            nextButtonDidTapEvent: nextButton.rx.tap.asObservable()
        )
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.mode
            .asDriver(onErrorJustReturn: .race)
            .drive(onNext: { [weak self] mode in
                self?.updateUI(mode: mode)
            }).disposed(by: self.disposeBag)
    }
    
    func updateUI(mode: RunningMode) {
        self.raceModeButton.backgroundColor = mode == .race ? .mrYellow : .white
        self.teamModeButton.backgroundColor = mode == .team ? .mrYellow: .white
        self.titleLabel.text = mode.title
        self.descriptionLabel.text = mode.description
    }
    
    func createModeButton(emoji: String, title: String) -> UIView {
        let view = UIView()
        let stackView = UIStackView()
        let emojiLabel = UILabel()
        let titleLabel = UILabel()
        
        view.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.notoSans(size: 40, family: .regular)
        titleLabel.text = title
        titleLabel.font = UIFont.notoSans(size: 20, family: .bold)
        titleLabel.textColor = .black
        
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.alignment = .center
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.layer.cornerRadius = 15
        view.addGestureRecognizer(UITapGestureRecognizer())
        return view
    }
    
    func nextButtonDidTap() {
        let mateSettingViewController = MateSettingViewController()
        self.navigationController?.pushViewController(mateSettingViewController, animated: true)
    }
}
