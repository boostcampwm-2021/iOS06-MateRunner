//
//  InvitationWaitingViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class InvitationWaitingViewController: UIViewController {
    var viewModel: InvitationWaitingViewModel?
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        activityIndicator.color = .mrPurple
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var indicateLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 14, family: .regular)
        label.text = """
                     메이트의 초대 수락을 기다리고 있습니다.
                     초대가 수락되면 달리기가 바로 시작됩니다.
                     """
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        let input = InvitationWaitingViewModel.Input(viewDidLoadEvent: Observable.just(())
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.requestSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] requestSuccess in
                if requestSuccess == false {
                    self?.showAlert(message: "초대장 전송 중 오류가 발생했습니다.")
                }
            })
            .disposed(by: self.disposeBag)
        
        output?.isRejected
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isRejected in
                if isRejected == true {
                    self?.showAlert(message: "메이트가 초대를 거절했습니다.")
                }
            })
            .disposed(by: self.disposeBag)
        
        output?.isCancelled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCancelled in
                if isCancelled == true {
                    self?.showAlert(message: "응답 대기 시간 초과로 달리기가 취소되었습니다.")
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.viewModel?.alertConfirmButtonDidTap()
        })
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
    
    func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(indicateLabel)
        self.view.addSubview(activityIndicator)
        
        self.indicateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
        
        self.activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
    }
}
