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
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(MateTableViewCell.self, forCellReuseIdentifier: MateTableViewCell.identifier)
        tableView.register(MateHeaderView.self, forHeaderFooterViewReuseIdentifier: MateHeaderView.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.addEmptyView()
        self.bindViewModel()
    }
}

// MARK: - Private Functions

private extension AddMateViewController {
    func configureUI() {
        self.navigationItem.title = "친구 검색"
        self.view.backgroundColor = .white
        
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
    
    func bindViewModel() {
        let input = AddMateViewModel.Input(
            searchCompletedEvent: self.mateSearchBar.rx.searchButtonClicked.asObservable(),
            searchBarEvent: self.mateSearchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.loadData
            .asDriver(onErrorJustReturn: [:])
            .drive(onNext: { [weak self] mate in
                print(mate)
            })
            .disposed(by: self.disposeBag)
    }
    
    func addEmptyView() {
        let emptyView = MateEmptyView(
            title: "닉네임을 검색해서 메이트를 추가해보세요!",
            topOffset: 180
        )
        
        self.mateTableView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
}
