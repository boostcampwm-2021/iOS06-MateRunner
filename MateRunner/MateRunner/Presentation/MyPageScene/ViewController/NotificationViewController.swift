//
//  NotificationViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class NotificationViewController: UIViewController {
    var viewModel: NotificationViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

private extension NotificationViewController {
    func configureUI() {
        
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        let input = NotificationViewModel.Input(
            viewDidLoadEvent: Observable<Void>.just(())
        )
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}
