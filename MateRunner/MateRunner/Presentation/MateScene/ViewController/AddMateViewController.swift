//
//  AddMateViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/17.
//

import UIKit

import RxSwift

final class AddMateViewController: UIViewController {
    var viewModel: AddMateViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var mateSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "닉네임을 입력해주세요."
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var mateTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddMateTableViewCell.self, forCellReuseIdentifier: AddMateTableViewCell.addIdentifier)
        tableView.register(MateHeaderView.self, forHeaderFooterViewReuseIdentifier: MateHeaderView.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension AddMateViewController {
    func configureUI() {
        self.navigationItem.title = "친구 검색"
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.mateSearchBar)
        self.mateSearchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        
        self.view.addSubview(self.mateTableView)
        self.mateTableView.snp.makeConstraints { make in
            make.top.equalTo(self.mateSearchBar.snp.bottom).offset(0)
            make.right.left.bottom.equalToSuperview()
        }
        
        self.addEmptyView(title: "닉네임을 검색해서 메이트를 추가해보세요!")
    }
    
    func bindViewModel() {
        let input = AddMateViewModel.Input(
            searchCompletedEvent: self.mateSearchBar.rx.searchButtonClicked.asObservable(),
            searchBarEvent: self.mateSearchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.loadData
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.mateTableView.reloadData()
                self?.checkMateCount()
            })
            .disposed(by: self.disposeBag)
    }
    
    func addEmptyView(title: String) {
        let emptyView = MateEmptyView(
            title: title,
            topOffset: 180
        )
        
        self.mateTableView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    func removeEmptyView() {
        self.mateTableView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func checkMateCount() {
        self.removeEmptyView()
        if self.viewModel?.mate.count == 0 {
            self.addEmptyView(title: "해당 닉네임의 메이트가 없습니다.")
        }
    }
}

// MARK: - UITableViewDelegate

extension AddMateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewValue.tableViewCellHeight.value()
    }
}

// MARK: - UITableViewDataSource

extension AddMateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewValue.tableViewHeaderHeight.value()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateHeaderView.identifier) as? MateHeaderView else { return UITableViewHeaderFooterView() }
        header.updateUI(description: "검색 결과", value: self.viewModel?.mate.count ?? 0)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.mate.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AddMateTableViewCell.identifier,
            for: indexPath) as? AddMateTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let mate = self.viewModel?.mate[indexPath.row]
        cell.updateUI(name: mate?.key ?? "", image: mate?.value ?? "")
        
        return cell
    }
}

// MARK: - AddMateDelegate

extension AddMateViewController: AddMateDelegate {
    func addMate(nickname: String) {
        // fcm전송
    }
}
