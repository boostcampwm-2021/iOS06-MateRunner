//
//  DistanceSettingViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/01.
//

import Foundation
import RxSwift

final class DistanceSettingViewModel {
    var distance = BehaviorSubject(value: "5.00")
    
    distance2
        .map({ "\()"})
        .map(format)
        .subscribe(onNext: {
        
    })
    
}

// view(String) -> viewModel(String) -> UseCase(Double?) -> viewModel(String)

// --+ View +--
//
// textField -> String --> 스트림 -> Double -> 스트림 --> ViewModel
// view -> viewmodel -> usecase
// usecase --> stream --> viewmodel --> stream --> view

// --+ ViewModel +--
// 0 패딩
//
//

// --+ UseCase +--
// . 여러개인거
// 0 입력
// 99 초과 입력

// --+ Model +--
// distance: Double
//
//
