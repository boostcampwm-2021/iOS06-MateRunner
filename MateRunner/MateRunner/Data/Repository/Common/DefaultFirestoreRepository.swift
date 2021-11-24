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
        static let commitKey = ":commit"
        static let defaultHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    private enum FirestoreFieldParameters {
        static let updateMask = "updateMask.fieldPaths="
        static let readMask = "mask.fieldPaths="
    }
    
    private enum FirestoreCollections {
        static let runningResultPath = "/RunningResult"
        static let userPath = "/User"
        static let recordsPath = "/records"
        static let emojiPath = "/emojis"
    }
    
    private enum FirestoreFields {
        static let emoji = "emoji"
        static let userNickname = "userNickname"
        static let nickname = "nickname"
        static let distance = "distance"
        static let time = "time"
        static let height = "height"
        static let weight = "weight"
        static let images = "iamges"
        static let calorie = "calorie"
        static let mate = "mate"
    }
    
    let urlSession = DefaultURLSessionNetworkService()
    let userNickname: String
    
    init (userNickName: String?) {
        self.userNickname = userNickName ?? "unknownUser"
    }
    
    // MARK: - Running Result Update/Read
    func add(runningResult: RunningResult) -> Observable<Void> {
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
            .map({ _ in })
    }
    
    func fetchResult(of nickname: String, from startDate: Date, to endDate: Date) -> Observable<[RunningResult]?> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.recordsBetweenDate(from: startDate, to: endDate, of: nickname),
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        ).map({ data -> [RunningResult]? in
            guard let dto = try? JSONDecoder().decode(
                [QueryResultValue<RunningResultFirestoreDTO>].self,
                from: data
            ) else { return [] }
            return dto.compactMap({try? $0.document.toDomain()})
        })
    }
    
    func fetchResult(of nickname: String, from startOffset: Int, by limit: Int) -> Observable<[RunningResult]?> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.allRecords(of: nickname, from: startOffset, by: limit),
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        ).map({ data -> [RunningResult]? in
            guard let dto = try? JSONDecoder().decode(
                [QueryResultValue<RunningResultFirestoreDTO>].self,
                from: data
            ) else { return [] }
            return dto.compactMap({try? $0.document.toDomain()})
        })
    }
    
    // MARK: - Emoji Update/Read/Delete
    func add(emoji: Emoji, to mateNickname: String, of runningID: String) -> Observable<Void> {
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
            .map({ _ in })
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
    
    // MARK: - UserInformation Read/Delete
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
    
    func add(userProfile: UserProfile) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(self.userNickname)?"
        + [FirestoreFieldParameters.updateMask + FirestoreFields.height,
           FirestoreFieldParameters.updateMask + FirestoreFields.weight,
           FirestoreFieldParameters.updateMask + FirestoreFields.images
        ].joined(separator: "&")
        
        let dto = UserProfileFirestoreDTO(userProfile: userProfile)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
            .map({ _ in })
    }
    
    // MARK: - TotalRecord Update/Read
    func add(totalRecord: TotalPresonalRecord, of nickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(nickname)?"
        + [FirestoreFieldParameters.updateMask + FirestoreFields.calorie,
           FirestoreFieldParameters.updateMask + FirestoreFields.distance,
           FirestoreFieldParameters.updateMask + FirestoreFields.time
        ].joined(separator: "&")
        let dto = TotalPresonalRecordDTO(totalRecord: totalRecord)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
            .map({ _ in })
    }
    
    func fetchTotalPeronsalRecord(of nickname: String) -> Observable<TotalPresonalRecord?> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(nickname)?"
        + [FirestoreFieldParameters.readMask + FirestoreFields.calorie,
           FirestoreFieldParameters.readMask + FirestoreFields.distance,
           FirestoreFieldParameters.readMask + FirestoreFields.time
        ].joined(separator: "&")
        
        return self.urlSession.get(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
            .map({ data -> TotalPresonalRecord? in
                guard let dto = try? JSONDecoder().decode(TotalPresonalRecordDTO.self, from: data) else {
                    return nil
                }
                return dto.toDomain()
            })
    }
    
    // MARK: - User Create/Delete
    func add(user: UserData) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(user.nickname)"
        
        let dto = UserFirestoreDTO(userData: user)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        )
            .map({ _ in })
    }
    
    func remove(user nickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(nickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
    }
    
    // MARK: - Mate Read/Update/Delete
    func fetchMate(of nickname: String) -> Observable<[String]?> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreCollections.userPath
        + "/\(nickname)?"
        + FirestoreFieldParameters.readMask + FirestoreFields.mate

        return self.urlSession.get(url: endPoint, headers: FirestoreEndPoints.defaultHeaders)
            .map({ data -> [String]? in
                guard let mates = try? JSONDecoder().decode(MatesDTO.self, from: data) else {
                    return nil
                }
                return mates.toDomain()
            })
    }
    
    func add(mate nickname: String, to targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.commitKey
        
        return self.urlSession.post(
            FirestoreQuery.append(mate: nickname, to: targetNickname),
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        ).map({ _ in })
    }
    
    func remove(mate nickname: String, from targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreEndPoints.baseURL
        + FirestoreEndPoints.documentsPath
        + FirestoreEndPoints.commitKey
        
        return self.urlSession.post(
            FirestoreQuery.remove(mate: nickname, from: targetNickname),
            url: endPoint,
            headers: FirestoreEndPoints.defaultHeaders
        ).map({ _ in })
    }
}
