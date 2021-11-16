//
//  RxTimerService.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/16.
//

import Foundation

import RxSwift

protocol RxTimerService {
    var disposeBag: DisposeBag { get set }
    func start() -> Observable<Int>
    func stop()
}
