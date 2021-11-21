//
//  RunningResultViewController.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/20.
//

import UIKit

import MapKit
import RxSwift

class RunningResultViewController: UIViewController {
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var scrollView = UIScrollView()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        let xImage = UIImage(systemName: "xmark")
        button.setImage(xImage, for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    lazy var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2020. 6. 10. - 오후 4:32"
        label.font = .notoSans(size: 18, family: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var korDateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "수요일 오후"
        label.font = .notoSans(size: 24, family: .medium)
        return label
    }()
    
    lazy var runningModeLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 24, family: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var upperSeparator = self.createSeparator()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "5.00"
        label.font = .notoSansBoldItalic(size: 64)
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 2
        label.layer.shadowColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
        return label
    }()
    
    lazy var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "128"
        label.font = .notoSans(size: 24, family: .black)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "24:50"
        label.font = .notoSans(size: 24, family: .black)
        return label
    }()
    
    lazy var myResultView = MyResultView(
        distanceLabel: self.distanceLabel,
        calorieLabel: self.calorieLabel,
        timeLabel: self.timeLabel
    )
    
    lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubviews()
        self.configureCommonUI()
    }
    
    func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    func configureMapViewLocation(from region: Region) {
        let coordinateLocation = region.center
        let spanValue = MKCoordinateSpan(latitudeDelta: region.span.0, longitudeDelta: region.span.1)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        self.mapView.setRegion(locationRegion, animated: true)
    }
    
    func configureMap() {
        self.mapView.delegate = self
        self.mapView.mapType = .standard
    }
    
    func configureSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.dateTimeLabel)
        self.contentView.addSubview(self.korDateTimeLabel)
        self.contentView.addSubview(self.runningModeLabel)
        self.contentView.addSubview(self.upperSeparator)
        self.contentView.addSubview(self.myResultView)
    }
    
    func configureMapView(with upperView: UIView) {
        self.mapView.snp.makeConstraints { make in
            make.top.equalTo(upperView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func drawLine(with points: [CLLocationCoordinate2D]) {
        let line = MKPolyline(coordinates: points, count: points.count)
        self.mapView.addOverlay(line)
    }
    
    func showAlert() {
        let message = "달리기 결과 저장 중 오류가 발생했습니다."
        
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default, handler: { _ in
            //
        })
        alert.addAction(cancel)
        present(alert, animated: false, completion: nil)
    }
}

// MARK: - Private Functions

private extension RunningResultViewController {
    func configureCommonUI() {
        self.view.backgroundColor = .systemBackground
        self.configureScrollView()
        self.configureCloseButton()
        self.configureDateTimeLabel()
        self.configureKorDateTimeLabel()
        self.configureRunningTypeLabel()
        self.configureUpperSeparator()
        self.configureMyResultView()
    }
    
    func configureScrollView() {
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
    
    func configureCloseButton() {
        self.closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
    }
    
    func configureDateTimeLabel() {
        self.dateTimeLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15)
        }
    }
    
    func configureKorDateTimeLabel() {
        self.korDateTimeLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.dateTimeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func configureRunningTypeLabel() {
        self.runningModeLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.korDateTimeLabel.snp.bottom)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func configureUpperSeparator() {
        self.upperSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.runningModeLabel.snp.bottom).offset(15)
        }
    }
    
    func configureMyResultView() {
        self.myResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.upperSeparator.snp.bottom)
        }
    }
}

extension RunningResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .mrPurple
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
