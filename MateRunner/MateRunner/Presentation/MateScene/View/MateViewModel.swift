//
//  MateViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class MateViewModel {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    struct Output {
        //usecase에서 fetch 받고 순서맞춘 딕셔너리가 와야할 것 같음
        @BehaviorRelayProperty var mateInfo: [String:String]?
    }
}
