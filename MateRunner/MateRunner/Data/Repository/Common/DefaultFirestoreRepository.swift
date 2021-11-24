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
        static let queryKey = ":runQuery"
        static let maskFieldPath = "&mask.fieldPaths="
        static let defaultHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    private enum FirestoreCollections {
        static let runningResultPath = "/RunningResult"
        static let userPath = "/User"
        static let recordsPath = "/records"
        static let emojiPath = "/emojis"
    }
    
    let urlSession = DefaultURLSessionNetworkService()
    let userNickname: String
    
    init (userNickName: String?) {
        self.userNickname = userNickName ?? "unknownUser"
    }
    
    func save(runningResult: RunningResult) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.runningResultPath
        + "/\(self.userNickname)"
        + FirestoreCollections.recordsPath
        + "/\(runningResult.runningSetting.sessionId ?? "0")"
        
        guard let dto = try? RunningResultFirestoreDTO(runningResult: runningResult) else {
            return Observable.error(FirebaseServiceError.typeMismatchError)
        }
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
    }
    
    func save(emoji: Emoji, to mateNickname: String, of runningID: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollections.recordsPath
        + "/\(runningID)"
        + FirestoreCollections.emojiPath
        + "/\(self.userNickname)"
        
        let dto = EmojiFirestoreDTO(emoji: emoji.text(), userNickname: self.userNickname)
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
    }
    
    func remove(emoji: Emoji, from runningID: String, of mateNickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollections.recordsPath
        + "/\(runningID)"
        + FirestoreCollections.emojiPath
        + "/\(self.userNickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
    }
    
    func fetchResult(from here: Date, to there: Date, of nickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.dateBetween(from: here, to: there, of: nickname),
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
    }
    
    func fetchResult(of nickname, by limit: Int, from startOffset: Int) {
        // TODO: offset에서부터 limit개 만큼만 가져오기
    }
    
    func fetchEmojis(of runningID: String, from mateNickname: String) -> Observable<[String: Emoji]> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollections.recordsPath
        + "/\(runningID)"
        + FirestoreCollections.emojiPath
        
        return self.urlSession.get(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
            .map({ data -> [String: Emoji] in
                guard let documents = try? JSONDecoder().decode(DocumentsValue.self, from: data) else { return [:] }
                
                var emojis: [String: Emoji] = [:]
                
                documents.value.forEach({ document in
                    print(document.fields)
                    guard let emojiValue = document.fields["emoji"]?.value,
                          let userNickname = document.fields["userNickname"]?.value,
                          let emoji = Emoji(rawValue: emojiValue) else { return }
                    
                    print(emojiValue, userNickname)
                    emojis[userNickname] = emoji
                })
                return emojis
            })
    }
    
    func fetchUserInformation(of nickname: String) -> Observable<UserData?> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(nickname)"
        
        return self.urlSession.get(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
            .map({ data -> UserData? in
                guard let dto = try? JSONDecoder().decode(UserFirestoreDTO.self, from: data) else {
                    return nil
                }
                return dto.toDomain()
            })
    }
}
