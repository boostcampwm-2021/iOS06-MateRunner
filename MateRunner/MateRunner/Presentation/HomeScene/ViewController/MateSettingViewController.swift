//
//  InviteMateViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

final class MateSettingViewController: MateViewController {
    var viewModel: MateSettingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
    }
        
    override func configureNavigation() {
        self.navigationItem.title = "친구 목록"
    }
    
    override func moveToNext(mate: String) {
        self.viewModel?.mateDidSelect(nickname: mate)
    }
}
