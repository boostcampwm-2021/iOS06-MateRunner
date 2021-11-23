//
//  MateViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//
import UIKit

import RxSwift

enum MateTableViewValue: CGFloat {
    case tableViewCellHeight = 80
    case tableViewHeaderHeight = 35
    
    func value() -> CGFloat {
        return self.rawValue
    }
}

class MateViewController: UIViewController {
    var mateViewModel: MateViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var mateSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "닉네임을 입력해주세요."
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    lazy var mateTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MateTableViewCell.self, forCellReuseIdentifier: MateTableViewCell.identifier)
        tableView.register(MateHeaderView.self, forHeaderFooterViewReuseIdentifier: MateHeaderView.identifier)
        return tableView
    }()
    
    private lazy var nextBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "person-add"),
                                     style: .plain,
                                     target: self,
                                     action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
    
    func configureNavigation() {
        self.navigationItem.title = "친구 목록"
        self.navigationItem.rightBarButtonItem = nextBarButton
    }
    
    func moveToNext(mate: String) {
        self.mateViewModel?.pushMateProfile(of: mate)
    }
}

// MARK: - Private Functions
private extension MateViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
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
            searchBarTextEvent: self.mateSearchBar.rx.text.orEmpty.asObservable(),
            navigationButtonDidTapEvent: self.nextBarButton.rx.tap.asObservable(),
            searchButtonDidTap: self.mateSearchBar.rx.searchButtonClicked.asObservable()
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
        
        output?.doneButtonDidTap
            .asDriver(onErrorJustReturn: false)
            .filter { $0 == true }
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        output?.filteredMateArray
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.mateTableView.rx.items(
                    cellIdentifier: MateTableViewCell.identifier,
                    cellType: MateTableViewCell.self
                )
            ) { _, model, cell in
                cell.updateUI(name: model.key, image: model.value)
            }
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MateTableViewValue.tableViewCellHeight.value()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MateTableViewValue.tableViewHeaderHeight.value()
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
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let mate = self.mateViewModel?.filteredMate[indexPath.row]
//        guard let mateNickname = mate?.key else { return }
//        self.moveToNext(mate: mateNickname)
//    }
}
