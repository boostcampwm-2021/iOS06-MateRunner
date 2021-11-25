//
//  FilePath.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/26.
//

import Foundation

enum FilePath {
    static let license = Bundle.main.path(forResource: "license", ofType: "txt") ?? ""
}
