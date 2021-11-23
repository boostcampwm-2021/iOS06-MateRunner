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
        static let queryPath = ":runQuery"
        static let maskFieldPath = "&mask.fieldPaths="
        static let emojiField = "emojis"
    }
    let urlSession = DefaultURLSessionNetworkService()
    
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
        
        return self.urlSession.post(["fields": dto], url: endPoint, headers: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ])
    }
    
    func fetchResult(from here: Date, to there: Date, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.queryPath
        
        return self.urlSession.post(
            FirestoreQuery.dateBetween(from: here, to: there, of: userNickname),
            url: endPoint,
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        )
    }
    
    func sendEmoji(to mateNickname: String, runningID: String, with emoji: Emoji) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.recordsPath
        + "/\(mateNickname)"
        + "/\(runningID)"
        + "/hunihun956"
        
        
        
        self.urlSession.post(<#T##data: Decodable & Encodable##Decodable & Encodable#>, url: <#T##String#>, headers: <#T##[String : String]?#>)
        
    }
    
    func fetchEmojis(of runningID: String, from mateNickname: String) -> Observable<[String: String]?>{
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.recordsPath
        + "/\(mateNickname)"
        + "/\(runningID)"
        
        return self.urlSession.get(url: endPoint, headers: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ])
            .map({ data in
                guard let dto = try? JSONDecoder().decode(EmojisDTO.self, from: data) else {
                    return nil
                }
                return dto.toDomain()
            })
    }
}

enum FirestoreQuery {
    static func dateBetween(from here: Date, to there: Date, of userNickname: String) -> String {
        return
"""
{
    "structuredQuery": {
        "where": {
            "compositeFilter": {
                "op": "AND",
                "filters": [
                    {
                        "fieldFilter": {
                            "field": {
                                "fieldPath": "dateTime"
                            },
                            "op": "GREATER_THAN_OR_EQUAL",
                            "value": {
                                "timestampValue": "\(here.yyyyMMddTHHmmssSSZ)"
                            }
                        }
                    },
                    {
                        "fieldFilter": {
                            "field": {
                                "fieldPath": "dateTime"
                            },
                            "op": "LESS_THAN_OR_EQUAL",
                            "value": {
                                "timestampValue": "\(there.yyyyMMddTHHmmssSSZ)"
                            }
                        }
                    },
                    {
                        "fieldFilter": {
                            "field": {
                                "fieldPath": "username"
                            },
                            "op": "EQUAL",
                            "value": {
                                "stringValue": "\(userNickname)"
                            }
                        }
                    }
                ]
            }
        },
        "from": [
            {
                "collectionId": "records",
                "allDescendants": true
            }
        ]
    }
}
"""
    }
}

