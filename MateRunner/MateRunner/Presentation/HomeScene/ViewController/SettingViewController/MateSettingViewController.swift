//
//  MateSettingViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

import RxRelay
import RxSwift

final class MateSettingViewController: MateViewController {
    var viewModel: MateSettingViewModel?
    private let disposeBag = DisposeBag()
    private let mateDidSelectEvent = PublishRelay<String>()
    private let viewWillAppearEvent = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindViewModel()
        self.viewWillAppearEvent.accept(())
    }
        
    override func configureNavigation() {
        self.navigationItem.title = "친구 목록"
    }
    
    override func moveToNext(mate: String) {
        self.mateDidSelectEvent.accept(mate)
    }
    
    func bindViewModel() {
        let input = MateSettingViewModel.Input(
            viewWillAppearEvent: self.viewWillAppearEvent.asObservable(),
            mateDidSelectEvent: self.mateDidSelectEvent.asObservable()
        )
        
        self.viewModel?.transform(input: input, disposeBag: self.disposeBag)
            .mateIsNowRunningAlertShouldShow
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.showAlert(message: "해당 메이트가 달리기 중이어서 선택할 수 없습니다. 다른 메이트를 선택해주세요.")
            })
            .disposed(by: self.disposeBag)
    }
}

private extension MateSettingViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}
