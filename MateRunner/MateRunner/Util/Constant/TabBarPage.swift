//
//  TabBarPage.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import Foundation

enum TabBarPage: String, CaseIterable {
    case home, record, mate, mypage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .record
        case 2: self = .mate
        case 3: self = .mypage
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .record: return 1
        case .mate: return 2
        case .mypage: return 3
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}
