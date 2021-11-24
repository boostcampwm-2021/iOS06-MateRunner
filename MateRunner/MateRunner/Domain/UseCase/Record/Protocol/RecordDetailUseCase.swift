//
//  RecordDetailUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/23.
//

import Foundation

protocol RecordDetailUseCase {
    var runningResult: RunningResult { get }
    var nickname: String? { get }
}
