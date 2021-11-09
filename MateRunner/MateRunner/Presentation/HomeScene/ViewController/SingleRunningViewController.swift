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

class SingleRunningViewController: UIViewController {
	let singleRunningViewModel = SingleRunningViewModel(
		runningUseCase: DefaultRunningUseCase()
	)
	private var disposeBag = DisposeBag()
	
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
	private lazy var calorieView = RunningInfoView(name: "칼로리", value: "128")
	private lazy var timeView = RunningInfoView(name: "시간", value: "24:50")
    private lazy var mapContainerView = UIView()
    private lazy var mapViewController = MapViewController()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 100)
        return label
    }()
    
	lazy var progressView = RunningProgressView(width: 250, color: .mrPurple)
    lazy var distanceStackView = self.createDistanceStackView()
	
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
	
	private lazy var cancelInfoFloatingView: UILabel = {
		let label = UILabel()
		label.text = "2초 동안 길게 탭하면 달리기가 종료돼요😉"
		label.layer.backgroundColor = UIColor.white.cgColor.copy(alpha: 0.85)
		label.layer.cornerRadius = 15
		label.textAlignment = .center
		label.isHidden = true
		label.font = .notoSans(size: 13, family: .light)
		label.addShadow(offset: CGSize(width: 2.0, height: 2.0))
		return label
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
		self.contentStackView.addArrangedSubview(runningView)
		self.contentStackView.addArrangedSubview(mapContainerView)
		
		self.addChild(self.mapViewController)
		self.mapViewController.view.frame = self.mapContainerView.frame
		self.mapContainerView.addSubview(self.mapViewController.view)
		self.mapViewController.backButtonDelegate = self
		
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
            make.bottom.equalTo(self.runningView.snp.centerY)
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
		
		self.view.addSubview(self.cancelInfoFloatingView)
		self.cancelInfoFloatingView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalTo(self.cancelButton.snp.top).offset(-50)
			make.height.equalTo(40)
			make.width.equalTo(300)
		}
	}
	
	func bindViewModel() {
		let input = SingleRunningViewModel.Input(
			viewDidLoadEvent: Observable.just(()),
			finishButtonLongPressDidBeginEvent: self.cancelButton.rx
				.longPressGesture()
				.when(.began)
				.map({ _ in })
				.asObservable(),
			finishButtonLongPressDidCancelEvent: self.cancelButton.rx
				.longPressGesture()
				.when(.ended, .cancelled, .failed)
				.map({ _ in })
				.asObservable(),
			finishButtonDidTapEvent: self.cancelButton.rx.tap
				.asObservable()
		)
		let output = self.singleRunningViewModel.transform(from: input, disposeBag: self.disposeBag)
		
		output.$timeSpent
			.asDriver()
			.drive(onNext: { [weak self] newValue in
				self?.timeView.updateValue(newValue: newValue)
			})
			.disposed(by: self.disposeBag)
		
		output.cancelTime
			.asDriver(onErrorJustReturn: "종료")
			.drive(onNext: { [weak self] newValue in
				self?.updateTimeLeftText(with: newValue)
			})
			.disposed(by: self.disposeBag)
		
		output.$navigateToResult
			.asDriver()
			.drive(onNext: { [weak self] navigateToResult in
				if navigateToResult == true { self?.navigateToResultScene() }
			})
			.disposed(by: self.disposeBag)
		
		output.isToasterNeeded
			.asDriver(onErrorJustReturn: false)
			.drive(onNext: {[weak self] isNeeded in
				self?.toggleCancelFolatingView(isNeeded: isNeeded)
			})
			.disposed(by: disposeBag)
		
		output.$distance
			.asDriver()
			.drive(onNext: { [weak self] distance in
				guard let distance = distance else { return }
                self?.distanceLabel.text = String(distance)
			})
			.disposed(by: self.disposeBag)
		
		output.$progress
			.asDriver()
			.drive(onNext: { [weak self] progress in
				guard let progress = progress else { return }
				self?.progressView.setProgress(Float(progress), animated: false)
			})
			.disposed(by: self.disposeBag)
    
        output.$calorie
            .asDriver()
            .drive(onNext: { [weak self] calorie in
                guard let calorie = calorie else { return }
                self?.calorieView.updateValue(newValue: "\(calorie)")
            })
            .disposed(by: self.disposeBag)
		
		output.$finishRunning
			.asDriver()
			.filter { $0 == true }
			.drive(onNext: { [weak self] _ in
				self?.navigateToResultScene()
			})
			.disposed(by: self.disposeBag)
	}
	
	func navigateToResultScene() {
		let runningResultViewController = RunningResultViewController()
		self.navigationController?.pushViewController(runningResultViewController, animated: true)
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
        outerStackView.spacing = 15
        
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.addArrangedSubview(self.progressView)
        return outerStackView
    }
}

extension SingleRunningViewController: BackButtonDelegate {
	func backButtonDidTap() {
		let toX = self.scrollView.contentOffset.x - self.scrollView.bounds.width
		let toY = self.scrollView.contentOffset.y
		self.scrollView.setContentOffset(CGPoint(x: toX, y: toY), animated: true)
	}
}
