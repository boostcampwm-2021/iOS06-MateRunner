//
//  SignUpValidationError.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/30.
//

import Foundation

enum SignUpValidationError: Error {
    case nicknameDuplicatedError
    case requiredDataMissingError
    
    var description: String {
        switch self {
        case .nicknameDuplicatedError:
            return "이미 존재하는 닉네임입니다"
        case .requiredDataMissingError:
            return "알 수 없는 에러"
        }
    }
}
