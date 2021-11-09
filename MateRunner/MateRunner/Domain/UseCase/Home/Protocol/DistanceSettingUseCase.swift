//
//  DistanceSettingUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/04.
//

import Foundation

import RxSwift

protocol DistanceSettingUseCase {
	var validatedText: BehaviorSubject<String?> {get set}
	func validate(text: String)
}
