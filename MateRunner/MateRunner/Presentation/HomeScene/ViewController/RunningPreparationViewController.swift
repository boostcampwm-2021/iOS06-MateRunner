//
//  RunningPreparationViewController.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class RunningPreparationViewController: UIViewController {
    var viewModel: RunningPreparationViewModel?
	let disposeBag = DisposeBag()
	
	private lazy var timeLeftLabel: UILabel = {
		let label = UILabel()
		label.font = .notoSansBoldItalic(size: 130)
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureUI()
		self.bindViewModel()
	}
}

private extension RunningPreparationViewController {
	func configureUI() {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		self.view.layer.backgroundColor = UIColor.mrYellow.cgColor
		self.view.addSubview(self.timeLeftLabel)
		self.timeLeftLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
		}
	}
	
	func bindViewModel() {
		let input = RunningPreparationViewModel.Input(viewDidLoadEvent: Observable.just(()))
		let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
		
		output?.$timeLeft
			.asDriver()
			.drive(onNext: { [weak self] updatedTime in
				self?.timeLeftLabel.text = updatedTime
				self?.timeLeftLabel.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
				UIView.animate(withDuration: 0.7) {
					self?.timeLeftLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
				}
			})
			.disposed(by: self.disposeBag)
		
		output?.$navigateToNext
			.asDriver()
			.filter({ $0 == true })
			.drive(onNext: { _ in
				let singleRunningViewController = SingleRunningViewController()
				self.navigationController?.pushViewController(singleRunningViewController, animated: true)
			})
			.disposed(by: self.disposeBag)
	}
}
