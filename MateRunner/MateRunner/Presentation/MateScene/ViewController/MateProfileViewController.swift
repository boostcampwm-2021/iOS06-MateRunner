//
//  MateProfileViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import UIKit

import RxCocoa
import RxSwift

enum MateProfileTableViewValue: CGFloat {
    case profileSectionCellHeight = 300
    case recordSectionCellHeight = 130
    case headerHeight = 50
    
    func value() -> CGFloat {
        return self.rawValue
    }
}

enum MateProfileTableViewSection: Int {
    case profileSection = 0
    case recordSection = 1
    
    func number() -> Int {
        return self.rawValue
    }
}

class MateProfileViewController: UIViewController {
    var viewModel: MateProfileViewModel?
    private let disposeBag = DisposeBag()
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            MateRecordTableViewCell.self,
            forCellReuseIdentifier: MateRecordTableViewCell.identifier
        )
        tableView.register(
            MateProfilTableViewCell.self,
            forCellReuseIdentifier: MateProfilTableViewCell.identifier
        )
        tableView.register(
            MateHeaderView.self,
            forHeaderFooterViewReuseIdentifier: MateHeaderView.identifier
        )
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension MateProfileViewController {
    func configureUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = MateProfileViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.loadProfile
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        output?.loadRecord
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadSections(
                    IndexSet(1...1),
                    with: .none
                )
            })
            .disposed(by: self.disposeBag)
        
        output?.reloadData
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        self.viewModel?.selectEmoji
            .asDriver(onErrorJustReturn: .clap)
            .drive(onNext: { [weak self] emoji in
                guard let index = self?.viewModel?.selectedIndex else { return }
                self?.viewModel?.recordInfo?[index].addEmoji(emoji, from: "yujin")
                self?.tableView.reloadSections(
                    IndexSet(1...1),
                    with: .none
                )
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension MateProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case MateProfileTableViewSection.profileSection.number():
            return MateProfileTableViewValue.profileSectionCellHeight.value()
        default:
            return MateProfileTableViewValue.recordSectionCellHeight.value()
        }
    }
}

// MARK: - UITableViewDataSource

extension MateProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case MateProfileTableViewSection.profileSection.number():
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MateProfilTableViewCell.identifier,
                for: indexPath
            ) as? MateProfilTableViewCell else { return UITableViewCell() }
            
            cell.addShadow(location: .bottom, color: .mrGray, opacity: 0.4, radius: 5.0)
            cell.selectionStyle = .none
            guard let profile = self.viewModel?.mateInfo else { return UITableViewCell() }
            cell.updateUI(
                imageURL: profile.image,
                nickname: profile.nickname,
                time: profile.time.timeString,
                distance: profile.distance.kilometerString,
                calorie: profile.calorie.calorieString
            )
            return cell
        case MateProfileTableViewSection.recordSection.number():
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MateRecordTableViewCell.identifier,
                for: indexPath
            ) as? MateRecordTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.indexPathRow = indexPath.row
            guard let result = self.viewModel?.recordInfo else { return UITableViewCell() }
            let nickname = self.viewModel?.fetchUserNickname()
            let record = result[indexPath.row]
            cell.updateUI(record: record)
            let emoji = record.emojis ?? [:]
            cell.updateHeartButton(nickname: "yujin", sender: Array(emoji.keys))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case MateProfileTableViewSection.recordSection.number():
            return MateProfileTableViewValue.headerHeight.value()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateHeaderView.identifier) as? MateHeaderView else {
                return UITableViewHeaderFooterView()
            }
        
        guard let profile = self.viewModel?.mateInfo else { return UITableViewHeaderFooterView() }
        header.updateUI(nickname: profile.nickname)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case MateProfileTableViewSection.profileSection.number():
            return 1
        case MateProfileTableViewSection.recordSection.number():
            return self.viewModel?.recordInfo?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let record = self.viewModel?.recordInfo?[indexPath.row]
            guard let record = record else { return }
            self.viewModel?.moveToDetail(record: record)
        }
    }
}

// MARK: - SendEmojiDelegate

extension MateProfileViewController: HeartButtonDidTapDelegate {
    func heartButtonDidTap(_ sender: MateRecordTableViewCell, isCanceled: Bool) {
        guard let selectedIndex = self.tableView.indexPath(for: sender)?.row,
              let result = self.viewModel?.recordInfo?[selectedIndex] else { return }
        self.viewModel?.selectedIndex = selectedIndex
        isCanceled
        ? self.viewModel?.removeEmoji(runningID: result.runningID, mate: "hunihun956")
        : self.viewModel?.moveToEmoji(record: result)
    }
}
