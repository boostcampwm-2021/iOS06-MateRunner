//
//  DefaultDistanceSettingUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/01.
//

import Foundation

import RxSwift

final class DefaultDistanceSettingUseCase: DistanceSettingUseCase {
    var validatedText: BehaviorSubject<String?> = BehaviorSubject(value: "5.00")
    
    func validate(text: String) {
        self.validatedText.onNext(self.checkValidty(of: text))
    }
    private func checkValidty(of distanceText: String) -> String? {
        // "." 문자는 최대 1개
        guard distanceText.filter({ $0 == "." }).count <= 1 else { return nil }
        
        // "." 이 없을 때는 문자 최대 2개
        if !distanceText.contains(".") && distanceText.count > 2 { return nil }
        
        // "." 이 있을 때는 앞뒤 모두 문자 최대 2개
        // 이미 .이 없을 때는 문자를 2개까지 밖에 입력하지 못하므로 앞은 확인 안해도 됨
        if distanceText.contains(".") && distanceText.components(separatedBy: ".")[1].count > 2 { return nil }
        
        return distanceText
    }
}
