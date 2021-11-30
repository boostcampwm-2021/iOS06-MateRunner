//
//  SignUpValidationState.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/30.
//

import Foundation

enum SignUpValidationState {
    case empty
    case lowerboundViolated
    case upperboundViolated
    case invalidLetterIncluded
    case success
    
    var description: String {
        switch self {
        case .empty, .success:
            return ""
        case .lowerboundViolated:
            return "최소 5자 이상 입력해주세요"
        case .upperboundViolated:
            return "최대 20자까지만 가능해요"
        case .invalidLetterIncluded:
            return "영문과 숫자만 입력할 수 있어요"
        }
    }
}
