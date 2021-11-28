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
    private let disposeBag = DisposeBag()
    
    private lazy var cumulativeRecordView = CumulativeRecordView()
    private lazy var calendarHeaderView = CalendarHeaderView()
    private lazy var headerView = UIView()
    
    private lazy var collectionView: CalendarView = {
        let collectionView = CalendarView()
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 20, family: .medium)
        return label
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 16, family: .medium)
        label.text = "이 날의 달리기 기록이 없네요 ☺️"
        label.isHidden = true
        return label
    }()
    
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let height = (self.view.bounds.width - 40) * 0.9 + 235
        let tableView = UITableView()
        tableView.register(RecordCell.self, forCellReuseIdentifier: RecordCell.identifier)
        tableView.tableHeaderView = self.headerView
        tableView.tableHeaderView?.frame.size.height = height
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame.size.height = 15
        tableView.rowHeight = 130
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = self.refreshControl
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
        
        self.configureHeaderView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView.addSubview(self.emptyLabel)
        self.emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.dateLabel.snp.bottom).offset(45)
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
        let input = RecordViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            previousButtonDidTapEvent: self.calendarHeaderView.previousButton.rx.tap.asObservable(),
            nextButtonDidTapEvent: self.calendarHeaderView.nextButton.rx.tap.asObservable(),
            calendarCellDidTapEvent: self.collectionView.rx.itemSelected.map { $0.row },
            recordCellDidTapEvent: self.tableView.rx.itemSelected.map { $0.row }
        )
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        self.bindCumulativeRecord(output: output)
        self.bindCalendarHeader(output: output)
        self.bindCalendar(output: output)
        self.bindRecord(output: output)
        
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
        
        output?.totalRecordDidUpdate
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(self.refreshControl.rx.isRefreshing)
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
    
    func bindCalendar(output: RecordViewModel.Output?) {
        output?.calendarArray
            .asDriver()
            .drive(
                self.collectionView.rx.items(
                    cellIdentifier: CalendarCell.identifier,
                    cellType: CalendarCell.self
                )
            ) { _, model, cell in
                cell.updateUI(with: model)
            }
            .disposed(by: self.disposeBag)
        
        output?.indicesToUpdate
            .asDriver()
            .drive(onNext: { [weak self] (previousIndex, currentIndex) in
                self?.updateBackground(index: previousIndex, isSelected: false)
                self?.updateBackground(index: currentIndex, isSelected: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindRecord(output: RecordViewModel.Output?) {
        output?.dailyRecords
            .asDriver()
            .drive(
                self.tableView.rx.items(
                    cellIdentifier: RecordCell.identifier,
                    cellType: RecordCell.self
                )
            ) { _, record, cell in
                cell.updateUI(record: record)
            }
            .disposed(by: self.disposeBag)
        
        output?.hasDailyRecords
            .asDriver()
            .compactMap { $0 }
            .drive(self.emptyLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    func updateBackground(index: Int?, isSelected: Bool) {
        guard let index = index else { return }
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? CalendarCell else { return }
        cell.updateBackground(isSelected: isSelected)
    }
}
