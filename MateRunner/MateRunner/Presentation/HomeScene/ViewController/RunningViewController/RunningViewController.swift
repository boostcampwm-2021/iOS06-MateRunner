//
//  RunningViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/18.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import SnapKit

class RunningViewController: UIViewController {
    var mapViewController: MapViewController?
    let disposeBag = DisposeBag()
    
    lazy var calorieView = RunningInfoView(name: "칼로리", value: "0")
    
    lazy var timeView = RunningInfoView(name: "시간", value: "00:00")
    
    lazy var cancelButton: UIButton = {
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
    private lazy var mapContainerView = UIView()
    private(set) lazy var distanceLabel = self.createDistanceLabel()
    private(set) lazy var progressView = self.createProgressView()
    private(set) lazy var distanceStackView = self.createDistanceStackView()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .mrPurple
        return pageControl
    }()
    
    private lazy var cancelInfoFloatingView: UILabel = {
        let label = UILabel()
        label.text = "2초 동안 길게 탭하면 달리기가 종료돼요😉"
        label.layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.85)
        label.layer.cornerRadius = 15
        label.textAlignment = .center
        label.isHidden = true
        label.font = .notoSans(size: 13, family: .light)
        label.textColor = .black
        label.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    func createDistanceLabel() -> UILabel {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 100)
        label.textColor = .black
        return label
    }
    
    func createProgressView() -> UIProgressView {
        return RunningProgressView(width: 250)
    }
    
    func createDistanceStackView() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.font = .notoSans(size: 16, family: .regular)
        nameLabel.textColor = .darkGray
        nameLabel.text = "킬로미터"
        
        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.alignment = .center
        innerStackView.spacing = -15
        
        innerStackView.addArrangedSubview(self.distanceLabel)
        innerStackView.addArrangedSubview(nameLabel)
        
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .center
        outerStackView.spacing = 30
        
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.addArrangedSubview(self.progressView)
        return outerStackView
    }
    
    func toggleCancelFolatingView(isNeeded: Bool) {
        func showCancelFloatingView() {
            guard self.cancelInfoFloatingView.isHidden == true else { return }
            self.cancelInfoFloatingView.alpha = 0.1
            self.cancelInfoFloatingView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.cancelInfoFloatingView.alpha = 1
            }
        }
        
        func hideCancelFloatingView() {
            UIView.animate(withDuration: 0.2, animations: {
                self.cancelInfoFloatingView.alpha = 0.1
            }, completion: { _ in
                self.cancelInfoFloatingView.isHidden = true
            })
        }
        isNeeded ? showCancelFloatingView() : hideCancelFloatingView()
    }
    
    func updateTimeLeftText(with text: String) {
        self.cancelButton.setTitle(text, for: .normal)
        self.cancelButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.7) {
            self.cancelButton.transform = CGAffineTransform.identity
        }
    }
}

// MARK: - Private Functions
private extension RunningViewController {
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
        
        self.configureRunningViewUI()
        self.configureMapContainerViewUI()
        
        self.view.addSubview(self.cancelInfoFloatingView)
        self.cancelInfoFloatingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.cancelButton.snp.top).offset(-50)
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
    }
    
    func configureMapContainerViewUI() {
        guard let mapViewController = self.mapViewController else { return }
        self.contentStackView.addArrangedSubview(mapContainerView)
        
        self.addChild(mapViewController)
        mapViewController.view.frame = self.mapContainerView.frame
        mapViewController.backButtonDelegate = self
        self.mapContainerView.addSubview(mapViewController.view)
    }
    
    func configureRunningViewUI() {
        self.runningView.backgroundColor = .mrYellow
        self.contentStackView.addArrangedSubview(runningView)
        
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
        
        self.runningView.addSubview(self.distanceStackView)
        self.distanceStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
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
}

extension RunningViewController: BackButtonDelegate {
    func backButtonDidTap() {
        let toX = self.scrollView.contentOffset.x - self.scrollView.bounds.width
        let toY = self.scrollView.contentOffset.y
        self.scrollView.setContentOffset(CGPoint(x: toX, y: toY), animated: true)
    }
}
