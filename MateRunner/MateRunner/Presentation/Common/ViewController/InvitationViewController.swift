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
            acceptButtonDidTapEvent: self.invitationView.acceptButton.rx.tap.asObservable(),
            rejectButtonDidTapEvent: self.invitationView.rejectButton.rx.tap.asObservable())
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        guard let output = output else { return }
    
        self.invitationView.updateTitleLabel(with: output.host)
        self.invitationView.updateModeLabel(with: output.mode)
        self.invitationView.updateDistanceLabel(with: output.targetDistance)
        
        output.cancelledAlertShouldShow
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert(message: "취소된 달리기입니다.")
            })
            .disposed(by: self.disposeBag)
    }
    
    func configureUI() {        
        self.view.addSubview(invitationView)
        self.invitationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel?.finish()
        })
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}
