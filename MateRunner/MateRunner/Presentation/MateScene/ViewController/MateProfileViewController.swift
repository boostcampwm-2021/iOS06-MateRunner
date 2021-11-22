//
//  MateProfileViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import UIKit

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
            viewDidLoadEvent: Observable.just(())
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)

        output?.loadProfile
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadSections(
                    IndexSet(0...0),
                    with: .automatic)
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
            guard let profile = self.viewModel?.mateInfo else { return UITableViewCell() }
            cell.updateUI(
                image: "",
                nickname: profile.nickname,
                time: "\(profile.time)",
                distance: "\(profile.distance)",
                calorie: "\(profile.calorie)"
            )
            return cell
        case MateProfileTableViewSection.recordSection.number():
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MateRecordTableViewCell.identifier,
                for: indexPath
            ) as? MateRecordTableViewCell else { return UITableViewCell() }

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

        header.updateUI(nickname: self.viewModel?.mateInfo?.nickname ?? "")
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case MateProfileTableViewSection.profileSection.number():
            return 1
        case MateProfileTableViewSection.recordSection.number():
            // TODO: 파베에서 fetch 한 개수로 update
            return 10
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        기록 결과화면 전환
    }
 }
