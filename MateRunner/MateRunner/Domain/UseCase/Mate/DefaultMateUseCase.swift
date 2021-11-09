//
//  DefaultMateUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import Foundation

import RxSwift

final class DefaultMateUseCase: MateUseCase {
    var mate: BehaviorSubject<[String: String]> = BehaviorSubject(value: [:])
    
    func fetchMateInfo() {
        // 파베에서 받고 순서맞춰주는 작업
        self.mate.onNext(["1": "hunihun956", "2": "Jungwon"])
    }
}
