//
//  SingleRunningViewController.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/04.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import SnapKit

final class SingleRunningViewController: UIViewController, UIScrollViewDelegate {
    private var disposeBag = DisposeBag()
	private let viewModel = SingleRunningViewModel(
		singleRunningUseCase: DefaultSingleRunningUseCase()
	)
	
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
    private lazy var mapView = UIView()
    
    private lazy var calorieView = RunningInfoView(name: "칼로리", value: "128")
    private lazy var timeView = RunningInfoView(name: "시간", value: "24:50")
    private lazy var distanceView = RunningInfoView(name: "킬로미터", value: "5.00", isLarge: true)
    private lazy var progressView = RunningProgressView(width: 250, color: .mrPurple)
    
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
		self.configureUI()
		self.bindViewModel()
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
        self.mapView.backgroundColor = .mrPurple
        self.contentStackView.addArrangedSubview(runningView)
        self.contentStackView.addArrangedSubview(mapView)
        
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
    
	func bindViewModel() {
		let output = self.viewModel.transform(
			from: SingleRunningViewModel.Input(
				viewDidLoadEvent: Observable.just(()),
				finishButtonLongPressDidBeginEvent: self.cancelButton.rx
					.longPressGesture()
					.when(.began)
					.map({ _ in })
					.asObservable(),
				finishButtonLongPressDidEndEvent: self.cancelButton.rx
					.longPressGesture()
					.when(.ended, .cancelled)
					.map({ _ in })
					.asObservable()
			),
			disposeBag: self.disposeBag
		)
		
		output.$timeSpent
			.asDriver()
			.drive(onNext: { [weak self] newValue in
				self?.timeView.updateValue(newValue: newValue)
			})
			.disposed(by: self.disposeBag)
		
		output.$cancelTime
			.asDriver()
			.drive(onNext: { [weak self] newValue in
				self?.cancelButton.setTitle(newValue, for: .normal)
				self?.cancelButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
				UIView.animate(withDuration: 0.7) {
					self?.cancelButton.transform = CGAffineTransform.identity
				}
			})
			.disposed(by: self.disposeBag)
		
		output.$navigateToResult
			.asDriver()
			.drive(onNext: { [weak self] navigateToResult in
				if navigateToResult == true {
					self?.navigateToResultScene()
				}
			})
			.disposed(by: self.disposeBag)
	}
    
    func navigateToResultScene() {
        let runningResultViewController = RunningResultViewController()
        self.navigationController?.pushViewController(runningResultViewController, animated: true)
    }
}
