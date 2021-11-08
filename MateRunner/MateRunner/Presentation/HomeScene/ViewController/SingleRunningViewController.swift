//
//  SingleRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SingleRunningViewController: UIViewController, UIScrollViewDelegate {
    private var disposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var runningView = UIView()
    private lazy var calorieView = RunningInfoView(name: "칼로리", value: "128")
    private lazy var timeView = RunningInfoView(name: "시간", value: "24:50")
    private lazy var distanceView = RunningInfoView(name: "킬로미터", value: "5.00", isLarge: true)
    private lazy var progressView = RunningProgressView(width: 250, color: .mrPurple)
    
    private lazy var mapContainerView = UIView()
    private lazy var mapViewController = MapViewController()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료", for: .normal)
        button.titleLabel?.font = .notoSans(size: 20, family: .bold)
        button.backgroundColor = .mrPurple
        button.layer.cornerRadius = 60
        button.addGestureRecognizer(UILongPressGestureRecognizer())
        button.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .mrPurple
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
}

// MARK: - Private Functions

private extension SingleRunningViewController {
    func configureUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
            make.width.equalTo(self.view.bounds.width * 2)
        }
        
        self.runningView.backgroundColor = .mrYellow
        self.contentStackView.addArrangedSubview(runningView)
        self.contentStackView.addArrangedSubview(mapContainerView)
        
        self.addChild(self.mapViewController)
        self.mapViewController.view.frame = self.mapContainerView.frame
        self.mapContainerView.addSubview(self.mapViewController.view)
        
        self.runningView.addSubview(self.calorieView)
        self.calorieView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        self.runningView.addSubview(self.timeView)
        self.timeView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        self.runningView.addSubview(self.distanceView)
        self.distanceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.runningView.snp.centerY).offset(-50)
        }

        self.runningView.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.runningView.snp.centerY).offset(-20)
        }

        self.runningView.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(100)
        }

        self.runningView.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(50)
        }
    }
    
    func bindUI() {
        self.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.cancelButtonDidTap()
            }).disposed(by: self.disposeBag)
    }
    
    func cancelButtonDidTap() {
        let runningResultViewController = RunningResultViewController()
        self.navigationController?.pushViewController(runningResultViewController, animated: true)
    }
}
