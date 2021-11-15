//
//  MateViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//
import UIKit

import RxSwift

enum TableViewValue: CGFloat {
    case tableViewCellHeight = 80
    case tableViewHeaderHeight = 35
    
    func value() -> CGFloat {
        return self.rawValue
    }
}

class MateViewController: UIViewController {
    var mateViewModel: MateViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var mateSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "닉네임을 입력해주세요."
        searchBar.backgroundImage = UIImage() // searchBar Border 없애기 위해
        return searchBar
    }()
    
    lazy var mateTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            MateTableViewCell.self,
            forCellReuseIdentifier: MateTableViewCell.identifier
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
    
    func configureNavigation() {
        self.navigationItem.title = "친구 목록"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.badge.plus"),
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    func moveToNext(mate: String) {
        // 친구 프로필로 이동
    }
}

// MARK: - Private Functions
private extension MateViewController {
    func configureUI() {
        self.configureNavigation()
        
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
        let input = MateViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            searchBarEvent: self.mateSearchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = self.mateViewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.$loadData
            .asDriver()
            .filter { $0 == true }
            .drive(onNext: { [weak self] _ in
                self?.mateTableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        output?.$filterData
            .asDriver()
            .filter { $0 == true }
            .drive(onNext: { [weak self] _ in
                self?.mateTableView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    
    func removeEmptyView() {
        self.mateTableView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func checkMateCount() {
        if self.mateViewModel?.filteredMate.count == 0 {
            self.addEmptyView()
        } else {
            self.removeEmptyView()
        }
    }
    
    func addEmptyView() {
        let emptyView = MateEmptyView(
            title: "등록된 메이트가 없습니다.\n메이트를 등록하고 함께 응원하며 달려보세요!",
            topOffset: 180
        )
        
        self.mateTableView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension MateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewValue.tableViewCellHeight.value()
    }
}

// MARK: - UITableViewDataSource
extension MateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewValue.tableViewHeaderHeight.value()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MateHeaderView.identifier) as? MateHeaderView else { return UITableViewHeaderFooterView() }
        header.updateUI(value: self.mateViewModel?.filteredMate.count ?? 0)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkMateCount()
        return self.mateViewModel?.filteredMate.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MateTableViewCell.identifier,
            for: indexPath) as? MateTableViewCell else { return UITableViewCell() }
        
        let mateDictionary = self.mateViewModel?.filteredMate ?? [:]
        let mateKey = Array(mateDictionary)[indexPath.row]
        cell.updateUI(image: mateKey.key, name: mateKey.value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 친구 탭바 - 닉네임 가지고 프로필 페이지로 이동
        // 친구 초대 - 닉네임 가지고 초대장 보내야함
        let mateDictionary = self.mateViewModel?.filteredMate ?? [:]
        let mateKey = Array(mateDictionary)[indexPath.row]
        let mateNickname = mateKey.value
        self.moveToNext(mate: mateNickname)
    }
}
