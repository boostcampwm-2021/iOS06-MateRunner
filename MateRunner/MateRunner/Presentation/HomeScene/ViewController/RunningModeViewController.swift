//
//  RunningModeViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/01.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class RunningModeViewController: UIViewController {
    private let viewModel = RunningModeViewModel()
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
    
    private lazy var raceModeButton = createModeButton(emoji: "🤜", title: "경쟁 모드")
    private lazy var teamModeButton = createModeButton(emoji: "🤝", title: "협동 모드")
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .notoSans(size: 16, family: .bold)
        button.layer.cornerRadius = 10
        button.backgroundColor = .mrPurple
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
    }
}

// MARK: - Private Functions

private extension RunningModeViewController {
    func configureUI() {
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "달리기 모드"
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.height.equalTo(45)
        }
        self.view.addSubview(self.raceModeButton)
        self.raceModeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(30)
            make.height.equalTo(80)
        }
        self.view.addSubview(self.teamModeButton)
        self.teamModeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.raceModeButton.snp.bottom).offset(20)
            make.height.equalTo(80)
        }
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func bindUI() {
        self.raceModeButton.gestureRecognizers?.first?.rx.event.bind { [weak self] _ in
            self?.viewModel.changeMode(to: .race)
        }.disposed(by: disposeBag)
        
        self.teamModeButton.gestureRecognizers?.first?.rx.event.bind { [weak self] _ in
            self?.viewModel.changeMode(to: .team)
        }.disposed(by: disposeBag)
        
        self.viewModel.mode.bind { [weak self] mode in
            self?.updateUI(mode: mode)
        }.disposed(by: disposeBag)
        
        self.nextButton.rx.tap.bind { [weak self] in
            self?.nextButtonDidTap()
        }.disposed(by: disposeBag)
    }
    
    func updateUI(mode: RunningMode) {
        raceModeButton.backgroundColor = mode == .race ? .mrYellow : .systemGray5
        teamModeButton.backgroundColor = mode == .race ? .systemGray5: .mrYellow
        titleLabel.text = mode == .race ? "경쟁 모드" : "협동 모드"
        descriptionLabel.text = mode == .race ? "정해진 거리를 누가 더 빨리 달리는지 메이트와 대결해보세요!" : "정해진 거리를 메이트와 함께 달려서 달성해보세요!"
    }
    
    func createModeButton(emoji: String, title: String) -> UIView {
        let view = UIView()
        let stackView = UIStackView()
        let emojiLabel = UILabel()
        let titleLabel = UILabel()
        
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.notoSans(size: 40, family: .regular)
        titleLabel.text = title
        titleLabel.font = UIFont.notoSans(size: 20, family: .bold)
        
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
        let distanceSettingViewController = DistanceSettingViewController()
        self.navigationController?.pushViewController(distanceSettingViewController, animated: true)
    }
}
