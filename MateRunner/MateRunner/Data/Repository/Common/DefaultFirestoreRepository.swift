//
//  DefaultFirestoreRepository.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/23.
//

import Foundation

import RxSwift

enum FirestoreRepositoryError: Error {
    case decodingError, encodingError
}

final class DefaultFirestoreRepository: FirestoreRepository {
    private let urlSession: URLSessionNetworkService
    
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
        + "/\(runningResult.runningID)"
        
        guard let dto = try? RunningResultFirestoreDTO(runningResult: runningResult) else {
            return Observable.error(FirestoreRepositoryError.encodingError)
        }
        
        return self.urlSession.patch(
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result -> Void in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func saveAll(
        runningResult: RunningResult,
        personalTotalRecord: PersonalTotalRecord,
        userNickname: String
    ) -> Observable<Void> {
        return Observable.zip(
            self.save(runningResult: runningResult, to: userNickname),
            self.save(totalRecord: personalTotalRecord, of: userNickname),
            resultSelector: { _, _ in }
        )
    }
    
    func fetchResult(of nickname: String, from startDate: Date, to endDate: Date) -> Observable<[RunningResult]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.recordsBetweenDate(from: startDate, to: endDate, of: nickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ queryResult -> [RunningResult] in
            switch queryResult {
            case .success(let data):
                guard let dto = self.decode(data: data, to: [QueryResultValue<RunningResultFirestoreDTO>].self) else {
                    throw FirestoreRepositoryError.decodingError
                }
                return dto.compactMap({try? $0.document.toDomain()})
            case .failure(let error):
                throw error
            }
        })
    }
    
    func fetchResult(of nickname: String, from startOffset: Int, by limit: Int) -> Observable<[RunningResult]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        
        return self.urlSession.post(
            FirestoreQuery.allRecords(of: nickname, from: startOffset, by: limit),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ queryResult -> [RunningResult] in
            switch queryResult {
            case .success(let data):
                guard let dto = self.decode(data: data, to: [QueryResultValue<RunningResultFirestoreDTO>].self) else {
                    throw FirestoreRepositoryError.decodingError
                }
                return dto.compactMap({ try? $0.document.toDomain() })
            case .failure(let error):
                throw error
            }
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
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).debug()
            .map({ result in
            switch result {
            case .success: break
            case .failure(let error):
                throw error
            }
        })
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
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
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
            .map({ result -> [String: Emoji] in
                switch result {
                case .success(let data):
                    guard let documents = self.decode(data: data, to: DocumentsValue.self) else {
                        return [:]
                    }
                    return self.parseEmojiFromDocuments(documents)
                case .failure(let error):
                    return [:]
                }
            })
    }
    
    private func parseEmojiFromDocuments(_ documents: DocumentsValue) -> [String: Emoji] {
        var emojis: [String: Emoji] = [:]
        documents.value.forEach({ document in
            guard let emojiValue = document.fields[FirestoreField.emoji]?.value,
                  let userNickname = document.fields[FirestoreField.userNickname]?.value,
                  let emoji = Emoji(rawValue: emojiValue) else { return }
            emojis[userNickname] = emoji
        })
        return emojis
    }
    
    // MARK: - UserInformation Read/Update/Delete
    func fetchUserData(of nickname: String) -> Observable<UserData> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)"
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> UserData in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: UserDataFirestoreDTO.self) else {
                        throw FirestoreRepositoryError.decodingError
                    }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func save(userProfile: UserProfile, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(userNickname)?"
        + [FirestoreFieldParameter.updateMask + FirestoreField.height,
           FirestoreFieldParameter.updateMask + FirestoreField.weight,
           FirestoreFieldParameter.updateMask + FirestoreField.image
        ].joined(separator: "&")
        
        let dto = UserProfileFirestoreDTO(userProfile: userProfile)
        
        return self.urlSession.patch(
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func fetchUserProfile(of userNickname: String) -> Observable<UserProfile> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(userNickname)?"
        + [FirestoreFieldParameter.readMask + FirestoreField.height,
           FirestoreFieldParameter.readMask + FirestoreField.weight,
           FirestoreFieldParameter.readMask + FirestoreField.image
        ].joined(separator: "&")
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> UserProfile in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: UserProfileFirestoreDTO.self) else {
                        throw FirestoreRepositoryError.decodingError
                    }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    // MARK: - TotalRecord Update/Read
    func save(totalRecord: PersonalTotalRecord, of nickname: String) -> Observable<Void> {
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
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func fetchTotalPeronsalRecord(of nickname: String) -> Observable<PersonalTotalRecord> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + [FirestoreFieldParameter.readMask + FirestoreField.calorie,
           FirestoreFieldParameter.readMask + FirestoreField.distance,
           FirestoreFieldParameter.readMask + FirestoreField.time
        ].joined(separator: "&")
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> PersonalTotalRecord in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: PersonalTotalRecordDTO.self) else {
                        throw FirestoreRepositoryError.decodingError
                    }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
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
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func remove(user nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    // MARK: - Mate Read/Update/Delete
    func fetchMate(of nickname: String) -> Observable<[String]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + FirestoreFieldParameter.readMask + FirestoreField.mate
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> [String] in
                switch result {
                case .success(let data):
                    guard let mates = self.decode(data: data, to: MateListFirestoreDTO.self) else {
                        throw FirestoreRepositoryError.decodingError
                    }
                    return mates.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func fetchFilteredMate(from text: String, of nickname: String) -> Observable<[String]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath
        + "/\(nickname)?"
        + FirestoreFieldParameter.readMask + FirestoreField.mate

        return self.urlSession.post(
            FirestoreQuery.nameFilter(by: text, selfNickname: nickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result -> [String] in
            switch result {
            case .success(let data):
                guard let mates = self.decode(data: data, to: [QueryResultValue<String>].self) else {
                    throw FirestoreRepositoryError.decodingError
                }
                return mates.compactMap({ $0.document })
            case .failure(let error):
                throw error
            }
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
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    // MARK: - Notice Read/Update
    func fetchNotice(of userNickname: String) -> Observable<[Notice]> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.notificationPath
        + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath
        
        return self.urlSession.get(
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result -> [Notice] in
            switch result {
            case .success(let data):
                guard let documents = self.decode(data: data, to: Documents<[NoticeDTO]>.self) else {
                    throw FirestoreRepositoryError.decodingError
                }
                return documents.documents.map { $0.toDomain() }
            case .failure(let error):
                throw error
            }
        })
    }
    
    func save(notice: Notice, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.notificationPath
        + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath
        
        let dto = NoticeDTO(from: notice)
        
        return self.urlSession.post(
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func updateState(notice: Notice, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.firestoreBaseURL + (notice.id ?? "")
        let dto = NoticeDTO(from: notice)
        
        return self.urlSession.patch(
            [FirestoreField.fields: dto],
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    func remove(mate nickname: String, from targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL
        + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.commitKey
        
        return self.urlSession.post(
            FirestoreQuery.remove(mate: nickname, from: targetNickname),
            url: endPoint,
            headers: FirestoreConfiguration.defaultHeaders
        ).map({ result in
            switch result {
            case .success: break
            case .failure(let error): throw error
            }
        })
    }
    
    private func decode<T: Decodable>(data: Data, to target: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(target, from: data)
        } catch {
            return nil
        }
    }
}

// MARK: - firestore request constants
extension DefaultFirestoreRepository {
    private enum FirestoreConfiguration {
        static let firestoreBaseURL = "https://firestore.googleapis.com/v1/"
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
        static let notificationPath = "/Notification"
    }
    
    private enum FirestoreField {
        static let fields = "fields"
        static let emoji = "emoji"
        static let userNickname = "userNickname"
        static let nickname = "nickname"
        static let distance = "distance"
        static let time = "time"
        static let height = "height"
        static let weight = "weight"
        static let image = "image"
        static let calorie = "calorie"
        static let mate = "mate"
    }
}
