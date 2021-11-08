//
//  RunningUseCase.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/05.
//

import Foundation

import RxSwift

protocol RunningUseCase { 
    var distance: BehaviorSubject<Double> { get set }
    var finishRunning: BehaviorSubject<Bool> { get set }
    func executePedometer()
 }
