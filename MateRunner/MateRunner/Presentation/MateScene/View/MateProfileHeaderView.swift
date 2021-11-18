//
//  MateProfileHeaderView.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/18.
//

import UIKit

final class MateProfileHeaderView: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.addShadow(location: .bottom)
        return view
    }()
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var cumulativeRecordView = CumulativeRecordView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: Self.identifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI() {
    }
}

// MARK: - Private Functions

private extension MateProfileHeaderView {
    func configureUI() {
        
    }
}
    
