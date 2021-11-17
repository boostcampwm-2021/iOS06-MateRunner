//
//  RecordViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/10/30.
//

import UIKit

final class RecordViewController: UIViewController {
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
        let height = (self.view.bounds.width - 40) * 0.9 + 215
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.tableHeaderView = self.headerView
        tableView.tableHeaderView?.frame.size.height = height
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
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
            make.top.equalTo(self.calendarHeaderView.snp.bottom).offset(10)
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
    
    func updateValue() {
        self.cumulativeRecordView.timeLabel.text = "12:34:56"
        self.cumulativeRecordView.distanceLabel.text = "5.9만"
        self.cumulativeRecordView.calorieLabel.text = "1,258"
        
        self.calendarHeaderView.dateLabel.text = "2021년 11월"
        self.calendarHeaderView.runningCountLabel.text = "10"
        self.calendarHeaderView.likeCountLabel.text = "120"
        
        self.dateLabel.text = "10월 26일의 달리기 기록"
    }
}

extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCell.identifier,
            for: indexPath
        ) as? CalendarCell {
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        let label = UILabel()
        label.text = "text"
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
