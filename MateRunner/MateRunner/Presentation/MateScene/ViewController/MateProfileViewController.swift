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
            MateTableViewCell.self,
            forCellReuseIdentifier: MateTableViewCell.identifier
        )
        tableView.register(
            MateProfileHeaderView.self,
            forHeaderFooterViewReuseIdentifier: MateProfileHeaderView.identifier
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - Private Functions

private extension MateProfileViewController {

}

// MARK: - UITableViewDelegate

extension MateProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - UITableViewDataSource

extension MateProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateProfileHeaderView.identifier) as? MateProfileHeaderView else {
                return UITableViewHeaderFooterView()
            }
        header.updateUI(time: "00:43", distance: "0.02", calorie: "143")
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MateTableViewCell.identifier,
            for: indexPath) as? MateTableViewCell else { return UITableViewCell() }
//
//        let mate = self.mateViewModel?.filteredMate[indexPath.row]
//        cell.updateUI(name: mate?.key ?? "", image: mate?.value ?? "")
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
}
