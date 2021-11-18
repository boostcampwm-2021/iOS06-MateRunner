//
//  InvitationViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class InvitationViewController: UIViewController {
    var viewModel: InvitationViewModel?
    private lazy var invitationView = InvitationView()
    private let disposeBag = DisposeBag()
    
    init(mate: String, mode: RunningMode, distance: Double) {
        super.init(nibName: nil, bundle: nil)
        self.invitationView = InvitationView(mate: mate, mode: mode, distance: distance)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
        self.bindViewModel()
    }
    
}

// MARK: - Private Functions

private extension InvitationViewController {
    func bindViewModel() {
        let input = InvitationViewModel.Input(viewDidLoadEvent: Observable.just(()))
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        Driver.zip(
            output?.host.asDriver(onErrorJustReturn: "") ?? Driver.just(""),
            output?.mode.asDriver(onErrorJustReturn: .team) ?? Driver.just(.team),
            output?.targetDistance.asDriver(onErrorJustReturn: 0) ?? Driver.just(0)
        ).asDriver(onErrorJustReturn: ("", .team, 0))
            .drive { host, mode, targetDistance in
                self.invitationView.updateLabelText(mate: host, mode: mode, distance: targetDistance)
            }
            .disposed(by: self.disposeBag)

    }
    
    func bindUI() {
        self.invitationView.acceptButton.rx.tap
            .subscribe(onNext: {
                self.viewModel?.acceptButtonDidTap()
            })
            .disposed(by: self.disposeBag)
        
        self.invitationView.rejectButton.rx.tap
            .subscribe(onNext: {
                self.viewModel?.rejectButtonDidTap()
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureUI() {
//        self.view.backgroundColor = UIColor.clear //이렇게 한다면 이전 뷰컨에서 addsubView로 배경의 투명도와 색을 지정해야함
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 투명도 있는 배경 -> animated: false
        self.view.isOpaque = false
        
        self.view.addSubview(invitationView)
        self.invitationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
