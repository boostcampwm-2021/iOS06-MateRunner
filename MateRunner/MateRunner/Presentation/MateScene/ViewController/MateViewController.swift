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
        label.text = "메이트 정보를 가져오고 있어요🏃‍♂️"
        return label
    }()

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
        tableView.keyboardDismissMode = .onDrag
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
    
    func bindViewModel() {
        let input = MateViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            searchBarTextEvent: self.mateSearchBar.rx.text.orEmpty.asObservable(),
            navigationButtonDidTapEvent: self.nextBarButton.rx.tap.asObservable(),
            searchButtonDidTap: self.mateSearchBar.rx.searchButtonClicked.asObservable()
        )
        
        let output = self.mateViewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.didLoadData
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.mateTableView.reloadData()
                self?.didLoadMate()
            })
            .disposed(by: self.disposeBag)
        
        output?.didFilterData
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.mateTableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        output?.doneButtonDidTap
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    func removeEmptyView() {
        self.mateTableView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func checkMateCount() {
        guard let initialLoad = self.mateViewModel?.initialLoad else { return }
        
        if self.mateViewModel?.filteredMate?.count == 0 && !(initialLoad) {
            self.addEmptyView()
        } else {
            self.removeEmptyView()
        }
    }
    
    func didLoadMate() {
        self.activityIndicator.stopAnimating()
        self.descriptionLabel.isHidden = true
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
        header.updateUI(value: self.mateViewModel?.filteredMate?.count ?? 0)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkMateCount()
        return self.mateViewModel?.filteredMate?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MateTableViewCell.identifier,
            for: indexPath) as? MateTableViewCell else { return UITableViewCell() }
        let mate = self.mateViewModel?.filteredMate?[indexPath.row]
        cell.updateUI(name: mate?.key ?? "", image: mate?.value ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mate = self.mateViewModel?.filteredMate?[indexPath.row]
        guard let mateNickname = mate?.key else { return }
        self.moveToNext(mate: mateNickname)
    }
}
