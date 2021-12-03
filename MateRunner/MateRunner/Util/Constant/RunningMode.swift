//
//  RunningMode.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/03.
//

import Foundation

enum RunningMode: String, Codable, Equatable {
    case single, race, team
    
    var title: String {
        switch self {
        case .race:
            return "경쟁 모드"
        case .team:
            return "협동 모드"
        case .single:
            return "혼자 달리기"
        }
    }
    
    var description: String {
        switch self {
        case .race:
            return "정해진 거리를 누가 더 빨리 달리는지 메이트와 대결해보세요!"
        case .team:
            return "정해진 거리를 메이트와 함께 달려서 달성해보세요!"
        case .single:
            return "혼자서 달려보세요!"
        }
    }
}
