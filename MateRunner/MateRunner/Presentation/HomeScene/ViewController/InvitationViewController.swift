//
//  InvitationViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

final class InvitationViewController: UIViewController {
    private lazy var invitationView = InvitationView()
    
    init(mate: String, mode: RunningMode, distance: Double) {
        super.init(nibName: nil, bundle: nil)
        self.invitationView = InvitationView(mate: mate, mode: mode, distance: distance)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
}

// MARK: - Private Functions

private extension InvitationViewController {
    func configureUI() {
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        self.view.addSubview(invitationView)
        self.invitationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
