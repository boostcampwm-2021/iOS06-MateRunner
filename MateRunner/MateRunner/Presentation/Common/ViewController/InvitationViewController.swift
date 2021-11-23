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
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension InvitationViewController {
    func bindViewModel() {
        let input = InvitationViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            acceptButtonDidTapEvent: self.invitationView.acceptButton.rx.tap.asObservable(),
            rejectButtonDidTapEvent: self.invitationView.rejectButton.rx.tap.asObservable())
        
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
        
        output?.cancelledAlertShouldShow.subscribe(
            onNext: { [weak self] cancelledAlertShouldShow in
                if cancelledAlertShouldShow {
                    self?.showAlert(message: "취소된 달리기입니다.")
                }
        })
            .disposed(by: self.disposeBag)

    }
    
    func configureUI() {
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.isOpaque = false
        
        self.view.addSubview(invitationView)
        self.invitationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: false, completion: { [weak self] in
            self?.viewModel?.finish()
        })
    }
}
