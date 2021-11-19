//
//  RecordViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

import RxCocoa
import RxSwift

final class RecordViewController: UIViewController {
    var viewModel: RecordViewModel?
    private var disposeBag = DisposeBag()
    
    private lazy var cumulativeRecordView = CumulativeRecordView()
    private lazy var calendarHeaderView = CalendarHeaderView()
    private lazy var headerView = UIView()
    
    private lazy var collectionView: CalendarView = {
        let collectionView = CalendarView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 20, family: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let height = (self.view.bounds.width - 40) * 0.9 + 235
        let tableView = UITableView()
        tableView.register(RecordCell.self, forCellReuseIdentifier: RecordCell.identifier)
        tableView.tableHeaderView = self.headerView
        tableView.tableHeaderView?.frame.size.height = height
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame.size.height = 15
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension RecordViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "기록"
        self.updateValue()
        
        self.configureHeaderView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureHeaderView() {
        self.headerView.addSubview(self.cumulativeRecordView)
        self.cumulativeRecordView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        self.headerView.addSubview(self.calendarHeaderView)
        self.calendarHeaderView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.cumulativeRecordView.snp.bottom).offset(30)
        }
        
        let weekdayView = WeekdayView()
        self.headerView.addSubview(weekdayView)
        weekdayView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.calendarHeaderView.snp.bottom).offset(20)
        }
        
        self.headerView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(self.collectionView.snp.width).multipliedBy(0.9)
        }
        
        self.headerView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.collectionView.snp.bottom).offset(30)
        }
    }
    
    func bindViewModel() {
        let input = RecordViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        self.bindCumulativeRecord(output: output)
        self.bindCalendarHeader(output: output)
        
        output?.monthDayDateText
            .asDriver()
            .drive(onNext: { [weak self] monthDayDateText in
                self?.dateLabel.text = "\(monthDayDateText)의 달리기 기록"
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindCumulativeRecord(output: RecordViewModel.Output?) {
        output?.timeText
            .asDriver()
            .drive(self.cumulativeRecordView.timeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.distanceText
            .asDriver()
            .drive(self.cumulativeRecordView.distanceLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.calorieText
            .asDriver()
            .drive(self.cumulativeRecordView.calorieLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindCalendarHeader(output: RecordViewModel.Output?) {
        output?.yearMonthDateText
            .asDriver()
            .drive(self.calendarHeaderView.dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.runningCountText
            .asDriver()
            .drive(self.calendarHeaderView.runningCountLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output?.likeCountText
            .asDriver()
            .drive(self.calendarHeaderView.likeCountLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func updateValue() {        
        self.calendarHeaderView.runningCountLabel.text = "10"
        self.calendarHeaderView.likeCountLabel.text = "120"
        
        self.dateLabel.text = "11월 18일의 달리기 기록"
    }
}

extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.identifier,
            for: indexPath
        ) as? CalendarCell else { return UICollectionViewCell() }
        if indexPath.row >= 0 && indexPath.row < 30 {
            cell.dayLabel.text = "\(indexPath.row + 1)"
        } else {
            cell.contentView.isHidden = true
        }
        return cell
    }
}

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordCell.identifier,
            for: indexPath
        ) as? RecordCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
