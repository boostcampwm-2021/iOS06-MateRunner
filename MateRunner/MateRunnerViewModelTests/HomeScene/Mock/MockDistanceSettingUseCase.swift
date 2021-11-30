//
//  MockDistanceSettingUseCase.swift
//  DistanceSettingTests
//
//  Created by 전여훈 on 2021/11/05.
//

import Foundation

import RxSwift

class MockDistanceSettingUseCase: DistanceSettingUseCase {
	var validatedText: BehaviorSubject<String?> = BehaviorSubject(value: "5.00")
	
	func validate(text: String) {
        if text.count >= 10 {
            self.validatedText.onNext(nil)
        } else {
            self.validatedText.onNext(text)
        }
	}
}
