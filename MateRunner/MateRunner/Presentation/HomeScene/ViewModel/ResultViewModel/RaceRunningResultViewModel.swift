//
//  RaceRunningResultViewModel.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/20.
//

import CoreLocation

import RxRelay
import RxSwift

class RaceRunningResultViewModel {
    private let runningResultUseCase: RunningResultUseCase
    weak var coordinator: RunningCoordinator?
    
    init(coordinator: RunningCoordinator, runningResultUseCase: RunningResultUseCase) {
        self.coordinator = coordinator
        self.runningResultUseCase = runningResultUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var dateTime: BehaviorRelay<String>
        var dayOfWeekAndTime: BehaviorRelay<String>
        var mode: BehaviorRelay<String>
        var distance: BehaviorRelay<String>
        var calorie: BehaviorRelay<String>
        var time: BehaviorRelay<String>
        var points: BehaviorRelay<[CLLocationCoordinate2D]>
        var region: BehaviorRelay<Region>
        var userNickname: BehaviorRelay<String>
        var selectedEmoji: BehaviorRelay<String>
        var mateDistance: BehaviorRelay<String>
        var headerMessage: BehaviorRelay<String>
        var resultMessage: BehaviorRelay<String>
        var saveFailAlertShouldShow: PublishRelay<Bool>
    }
}
