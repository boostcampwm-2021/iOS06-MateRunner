//
//  CoreMotionService.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/06.
//

import Foundation

import RxSwift

protocol CoreMotionService {
    func startPedometer() -> Observable<Double>
    func startActivity() -> Observable<Double>
    func stopPedometer()
    func stopAcitivity()
}
