//
//  RecordCoordinator.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/17.
//

import Foundation

protocol RecordCoordinator: Coordinator {
    func push(with runningResult: RunningResult)
}
