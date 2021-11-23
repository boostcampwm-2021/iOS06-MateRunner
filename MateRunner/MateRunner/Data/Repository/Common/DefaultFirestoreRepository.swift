//
//  DefaultFirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation
import RxSwift

class DefaultFirestoreRepository {
    private enum FirestoreEndPoints {
        static let baseURL = "https://firestore.googleapis.com/v1/projects/mate-runner-e232c"
        static let documentsPath = "/databases/(default)/documents"
        static let runningResultPath = "/RunningResult"
        static let recordsPath = "/records"
    }
    
    func save(runningResult: RunningResult, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.runningResultPath
        + "/\(userNickname)"
        + FirestoreEndPoints.recordsPath

        guard let dto = try? RunningResultFirestoreDTO(runningResult: runningResult)
        else {
            return Observable.error(FirebaseServiceError.typeMismatchError)
        }
        
        let urlSession = DefaultURLSessionNetworkService()
        return urlSession.post(["fields": dto], url: endPoint, headers: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ])
    }
}
