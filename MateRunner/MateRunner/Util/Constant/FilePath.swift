//
//  FilePath.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/26.
//

import Foundation

enum FilePath {
    static let license = Bundle.main.path(forResource: "license", ofType: "txt") ?? ""
    static let termsOfService = Bundle.main.path(forResource: "termsOfService", ofType: "txt") ?? ""
    static let termsOfPrivacy = Bundle.main.path(forResource: "termsOfPrivacy", ofType: "txt") ?? ""
    static let termsOfLocationService = Bundle.main.path(forResource: "termsOfLocationService", ofType: "txt") ?? ""
}
