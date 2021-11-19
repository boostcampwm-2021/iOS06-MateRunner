//
//  MateProfileViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import UIKit

class MateProfileViewController: UIViewController {
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
}

// MARK: - UITableViewDelegate

extension MateProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        default:
            return 130
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
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MateProfilTableViewCell.identifier,
                for: indexPath
            ) as? MateProfilTableViewCell else { return UITableViewCell() }
            
            cell.addShadow(location: .bottom, color: .mrGray, opacity: 0.4, radius: 5.0)
            cell.updateUI(image: "", nickname: "yujin", time: "00:43", distance: "0.35", calorie: "143")
            return cell
        case 1:
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
        case 1:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateHeaderView.identifier) as? MateHeaderView else {
                return UITableViewHeaderFooterView()
            }
        
        header.updateUI(nickname: "yujin")
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
}
