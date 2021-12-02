//
//  ImageEditButton.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/25.
//

import UIKit

final class ImageEditButton: UIView {
    private(set) lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        return imageView
    }()
    
    private lazy var cameraIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = .systemGray5
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
}

private extension ImageEditButton {
    func configureUI() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.addSubview(self.cameraIconView)
        self.cameraIconView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(86)
        }
    }
}
