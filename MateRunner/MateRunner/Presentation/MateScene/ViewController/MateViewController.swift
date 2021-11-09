//
//  MateViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

enum TableViewValue: CGFloat {
    case tableViewCellHeight = 80
    case tableViewHeaderHeight = 35
}

class MateViewController: UIViewController {
    private lazy var mateSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "닉네임을 입력해주세요."
        searchBar.backgroundImage = UIImage() // searchBar Border 없애기 위해
        return searchBar
    }()
    
    private lazy var mateTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MateTableViewCell.self, forCellReuseIdentifier: MateTableViewCell.identifier)
        tableView.register(MateHeaderView.self, forHeaderFooterViewReuseIdentifier: MateHeaderView.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

// MARK: - Private Functions

private extension MateViewController {
    func configureUI() {
        self.navigationItem.title = "친구 목록"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: nil)
        
        self.view.addSubview(self.mateSearchBar)
        self.mateSearchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        
        self.view.addSubview(self.mateTableView)
        self.mateTableView.snp.makeConstraints { make in
            make.top.equalTo(self.mateSearchBar.snp.bottom).offset(0)
            make.right.left.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension MateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewValue.tableViewCellHeight.rawValue
    }
}

// MARK: - UITableViewDataSource

extension MateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewValue.tableViewHeaderHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateHeaderView.identifier) as? MateHeaderView else { return UITableViewHeaderFooterView() }
        header.updateUI(value: 2)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MateTableViewCell.identifier,
            for: indexPath) as? MateTableViewCell else { return UITableViewCell() }
        
        cell.updateUI(image: "", name: "huni")
        
        return cell
    }
}
