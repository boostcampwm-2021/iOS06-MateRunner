//
//  DefaultFirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation
import RxSwift

class DefaultFirestoreRepository {
    private enum APIEndPoints {
        static let baseURL = URL(string: "https://firestore.googleapis.com/v1/projects/mate-runner-e232c/databases/(default)/documents/")
        static let runningResult = "RunningResult"
    }
    
    func save(runningResult: RunningResult) -> Observable<Void> {
        // 1. RunningResult JSON으로 인코딩
        // 2. URLSession POST 메서드로 다큐먼트 저장
        // 2-1. 엔드포인트 주소로 보내면 documentID는 자동으로 생성됨
        // 3. 저장결과 반환 -> 파베 rest에서 반환하는 에러타입들을 enum으로 들고있으면 좋을 듯?
        return Observable.just(())
    }
}
