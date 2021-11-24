//
//  DefaultFirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

import RxSwift

class DefaultFirestoreRepository {
    let urlSession: URLSessionNetworkService
    
    init(urlSessionService: URLSessionNetworkService) {
        self.urlSession = urlSessionService
    }

    // MARK: - Running Result Update/Read
    func save(runningResult: RunningResult, to userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath
        + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath
        + "/\(runningResult.runningSetting.sessionId ?? "0")"
        
        guard let dto = try? RunningResultFirestoreDTO(runningResult: runningResult) else {
            return Observable.error(FirebaseServiceError.typeMismatchError)
        }
        
        return self.urlSession.patch(["fields": dto], url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ _ in })
    }
    
    func fetchResult(of nickname: String, from startDate: Date, to endDate: Date) -> Observable<[RunningResult]?> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.recordsBetweenDate(from: startDate, to: endDate, of: nickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ queryResult -> [RunningResult]? in
            guard let dto = try? JSONDecoder().decode(
                [QueryResultValue<RunningResultFirestoreDTO>].self,
                from: queryResult
            ) else { return [] }
            return dto.compactMap({try? $0.document.toDomain()})
        })
    }
    
    func fetchResult(of nickname: String, from startOffset: Int, by limit: Int) -> Observable<[RunningResult]?> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.allRecords(of: nickname, from: startOffset, by: limit),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ queryResult -> [RunningResult]? in
            guard let dto = try? JSONDecoder().decode(
                [QueryResultValue<RunningResultFirestoreDTO>].self,
                from: queryResult
            ) else { return [] }
            return dto.compactMap({try? $0.document.toDomain()})
        })
    }
    
    // MARK: - Emoji Update/Read/Delete
    func save(
        emoji: Emoji,
        to mateNickname: String,
        of runningID: String,
        from userNickname: String
    ) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath
        + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath
        + "/\(userNickname)"
        
        let dto = EmojiFirestoreDTO(emoji: emoji.text(), userNickname: userNickname)
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
    
    func removeEmoji(
        from runningID: String,
        of mateNickname: String,
        with userNickname: String
    ) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath
        + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath
        + "/\(userNickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
    }
    
    func fetchEmojis(of runningID: String, from mateNickname: String) -> Observable<[String: Emoji]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath
        + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath
        + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ data -> [String: Emoji] in
                guard let documents = try? JSONDecoder().decode(DocumentsValue.self, from: data) else { return [:] }
                var emojis: [String: Emoji] = [:]
                
                documents.value.forEach({ document in
                    guard let emojiValue = document.fields["emoji"]?.value,
                          let userNickname = document.fields["userNickname"]?.value,
                          let emoji = Emoji(rawValue: emojiValue) else { return }
                    
                    print(emojiValue, userNickname)
                    emojis[userNickname] = emoji
                })
                return emojis
            })
    }
    
    // MARK: - UserInformation Read/Update/Delete
    func fetchUserData(of nickname: String) -> Observable<UserData?> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)"
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ data -> UserData? in
                guard let dto = try? JSONDecoder().decode(UserDataFirestoreDTO.self, from: data) else { return nil }
                return dto.toDomain()
            })
    }
    
    func save(userProfile: UserProfile, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(userNickname)?"
        + [FirestoreFieldParameter.updateMask + FirestoreField.height,
           FirestoreFieldParameter.updateMask + FirestoreField.weight,
           FirestoreFieldParameter.updateMask + FirestoreField.images
        ].joined(separator: "&")
        
        let dto = UserProfileFirestoreDTO(userProfile: userProfile)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
    
    // MARK: - TotalRecord Update/Read
    func save(totalRecord: PresonalTotalRecord, of nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + [FirestoreFieldParameter.updateMask + FirestoreField.calorie,
           FirestoreFieldParameter.updateMask + FirestoreField.distance,
           FirestoreFieldParameter.updateMask + FirestoreField.time
        ].joined(separator: "&")
        let dto = PersonalTotalRecordDTO(totalRecord: totalRecord)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
    
    func fetchTotalPeronsalRecord(of nickname: String) -> Observable<PresonalTotalRecord?> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + [FirestoreFieldParameter.readMask + FirestoreField.calorie,
           FirestoreFieldParameter.readMask + FirestoreField.distance,
           FirestoreFieldParameter.readMask + FirestoreField.time
        ].joined(separator: "&")
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ data -> PresonalTotalRecord? in
                guard let dto = try? JSONDecoder().decode(PersonalTotalRecordDTO.self, from: data) else {
                    return nil
                }
                return dto.toDomain()
            })
    }
    
    // MARK: - User Update/Delete
    func save(user: UserData) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(user.nickname)"
        
        let dto = UserDataFirestoreDTO(userData: user)
        
        return self.urlSession.patch(
            ["fields": dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
    
    func remove(user nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
    }
    
    // MARK: - Mate Read/Update/Delete
    func fetchMate(of nickname: String) -> Observable<[String]?> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + FirestoreFieldParameter.readMask + FirestoreField.mate

        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ data -> [String]? in
                guard let mates = try? JSONDecoder().decode(MateListFirestoreDTO.self, from: data) else {
                    return nil
                }
                return mates.toDomain()
            })
    }
    
    func save(mate nickname: String, to targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.commitKey
        
        return self.urlSession.post(
            FirestoreQuery.append(mate: nickname, to: targetNickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
    
    func remove(mate nickname: String, from targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.commitKey
        
        return self.urlSession.post(
            FirestoreQuery.remove(mate: nickname, from: targetNickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ _ in })
    }
}

extension DefaultFirestoreRepository {
    private enum FirestoreConfiguration {
        static let baseURL = "https://firestore.googleapis.com/v1/projects/mate-runner-e232c"
        static let documentsPath = "/databases/(default)/documents"
        static let queryKey = ":runQuery"
        static let commitKey = ":commit"
        static let defaultHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
    }
    private enum FirestoreFieldParameter {
        static let updateMask = "updateMask.fieldPaths="
        static let readMask = "mask.fieldPaths="
    }
    
    private enum FirestoreCollectionPath {
        static let runningResultPath = "/RunningResult"
        static let userPath = "/User"
        static let recordsPath = "/records"
        static let emojiPath = "/emojis"
    }
    
    private enum FirestoreField {
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
}
