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

final class NotificationViewController: UIViewController {
    var viewModel: NotificationViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var notificationTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            NotificationTableViewCell.self,
            forCellReuseIdentifier: NotificationTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

private extension NotificationViewController {
    func configureUI() {
        self.configureNavigationBar()
        self.view.addSubview(self.notificationTableView)
        self.notificationTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "알림"
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        let input = NotificationViewModel.Input(
            viewDidLoadEvent: Observable<Void>.just(())
        )
        
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationTableViewCell.identifier,
            for: indexPath
        ) as? NotificationTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
