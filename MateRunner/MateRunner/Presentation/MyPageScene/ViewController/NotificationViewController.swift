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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = self.view.center
        activityIndicator.color = .mrPurple
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .notoSans(size: 14, family: .medium)
        label.text = "받은 알림을 가져오고 있어요🔔"
        return label
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
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.notificationTableView)
        self.notificationTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
            make.width.height.equalTo(50)
        }
        
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.activityIndicator.snp.bottom).offset(10)
            make.width.equalTo(200)
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
        
        output.didLoadData
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.configureEmptyView()
                self?.notificationTableView.reloadData()
                self?.didLoadNotices()
            })
            .disposed(by: self.disposeBag)
    }
    
    func didLoadNotices() {
        self.activityIndicator.stopAnimating()
        self.descriptionLabel.isHidden = true
    }
    
    func configureEmptyView() {
        if self.viewModel?.notices.count == 0 {
            self.addEmptyView()
        } else {
            self.removeEmptyView()
        }
    }
    
    func addEmptyView() {
        let emptyView = MateEmptyView(
            title: "받은 알림이 없습니다.",
            topOffset: 180
        )
        
        self.notificationTableView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    func removeEmptyView() {
        self.notificationTableView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func showAlert(notice: Notice) {
        let alert = UIAlertController(
            title: "알림",
            message: "\(notice.sender)님의 메이트 요청을 수락하시겠습니까?",
            preferredStyle: .alert
        )
        let reject = UIAlertAction(
            title: "거부",
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel?.updateMateState(notice: notice, isAccepted: false)
            }
        )
        let confirm = UIAlertAction(
            title: "수락",
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel?.updateMateState(notice: notice, isAccepted: true)
            }
        )
        
        alert.addAction(reject)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.notices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationTableViewCell.identifier,
            for: indexPath
        ) as? NotificationTableViewCell,
              let notice = self.viewModel?.notices[indexPath.row] else {
            return UITableViewCell()
        }
        cell.updateUI(mode: notice.mode, sender: notice.sender, isReceived: notice.isReceived)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let notice = self.viewModel?.notices[indexPath.row] else { return }
        
        if !notice.isReceived && notice.mode == .requestMate {
            self.showAlert(notice: notice)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
