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
    typealias Error = FirestoreRepositoryError
    private let urlSession: URLSessionNetworkService
    
    init(urlSessionService: URLSessionNetworkService) {
        self.urlSession = urlSessionService
    }
    
    // MARK: - Running Result Update/Read
    func save(runningResult: RunningResult, to userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath + "/\(runningResult.runningID)"
        
        guard let dto = try? RunningResultFirestoreDTO(runningResult: runningResult) else {
            return Observable.error(Error.encodingError)
        }
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> Void in
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
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        let bodyData = FirestoreQuery.recordsBetweenDate(from: startDate, to: endDate, of: nickname)
        let decodeTarget = [QueryResultValue<RunningResultFirestoreDTO>].self
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ queryResult -> [RunningResult] in
                switch queryResult {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.compactMap({try? $0.document?.toDomain()})
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func fetchResult(of nickname: String, from startOffset: Int, by limit: Int) -> Observable<[RunningResult]> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        let bodyData = FirestoreQuery.allRecords(of: nickname, from: startOffset, by: limit)
        let decodeTarget = [QueryResultValue<RunningResultFirestoreDTO>].self
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ queryResult -> [RunningResult] in
                switch queryResult {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.compactMap({ try? $0.document?.toDomain() })
                case .failure(let error):
                    throw error
                }
            })
    }
    
    // MARK: - Emoji Update/Read/Delete
    func save(emoji: Emoji,
              to mateNickname: String,
              of runningID: String,
              from userNickname: String
    ) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath + "/\(userNickname)"
        let dto = EmojiFirestoreDTO(emoji: emoji.text(), userNickname: userNickname)
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func removeEmoji(from runningID: String, of mateNickname: String, with userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath + "/\(userNickname)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func fetchEmojis(of runningID: String, from mateNickname: String) -> Observable<[String: Emoji]> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.runningResultPath + "/\(mateNickname)"
        + FirestoreCollectionPath.recordsPath + "/\(runningID)"
        + FirestoreCollectionPath.emojiPath
        let decodeTarget = DocumentsValue.self
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> [String: Emoji] in
                switch result {
                case .success(let data):
                    guard let documents = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return self.parseEmojiFromDocuments(documents)
                case .failure(let error):
                    throw error
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
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(nickname)"
        let decodeTarget = UserDataFirestoreDTO.self
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> UserData in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func saveAll(userProfile: UserProfile, with newImageData: Data, of userNickname: String) -> Observable<Void> {
        return self.save(profileImageData: newImageData, of: userNickname)
            .flatMap({ imageDownloadURL -> Observable<Void> in
                let updatedProfile = UserProfile(
                    image: imageDownloadURL,
                    height: userProfile.height,
                    weight: userProfile.weight
                )
                return self.save(userProfile: updatedProfile, of: userNickname)
            })
    }
    
    func save(userProfile: UserProfile, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(userNickname)?"
        + [FirestoreFieldParameter.updateMask + FirestoreField.height,
           FirestoreFieldParameter.updateMask + FirestoreField.weight,
           FirestoreFieldParameter.updateMask + FirestoreField.image
        ].joined(separator: "&")
        let dto = UserProfileFirestoreDTO(userProfile: userProfile)
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func fetchUserProfile(of userNickname: String) -> Observable<UserProfile> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(userNickname)?"
        + [FirestoreFieldParameter.readMask + FirestoreField.height,
           FirestoreFieldParameter.readMask + FirestoreField.weight,
           FirestoreFieldParameter.readMask + FirestoreField.image
        ].joined(separator: "&")
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> UserProfile in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: UserProfileFirestoreDTO.self) else {
                        throw Error.decodingError
                    }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    // MARK: - TotalRecord Update/Read
    func save(totalRecord: PersonalTotalRecord, of nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(nickname)?"
        + [FirestoreFieldParameter.updateMask + FirestoreField.calorie,
           FirestoreFieldParameter.updateMask + FirestoreField.distance,
           FirestoreFieldParameter.updateMask + FirestoreField.time
        ].joined(separator: "&")
        
        let dto = PersonalTotalRecordDTO(totalRecord: totalRecord)
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func fetchTotalPeronsalRecord(of nickname: String) -> Observable<PersonalTotalRecord> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(nickname)?"
        + [FirestoreFieldParameter.readMask + FirestoreField.calorie,
           FirestoreFieldParameter.readMask + FirestoreField.distance,
           FirestoreFieldParameter.readMask + FirestoreField.time
        ].joined(separator: "&")
        let decodeTarget = PersonalTotalRecordDTO.self
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> PersonalTotalRecord in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    // MARK: - User Update/Delete
    func save(user: UserData) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(user.nickname)"
        
        let dto = UserDataFirestoreDTO(userData: user)
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func remove(user nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(nickname)"
        
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
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.userPath + "/\(nickname)?"
        + FirestoreFieldParameter.readMask + FirestoreField.mate
        let decodeTarget = MateListFirestoreDTO.self
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> [String] in
                switch result {
                case .success(let data):
                    guard let mates = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return mates.toDomain()
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func fetchFilteredMate(from text: String, of nickname: String) -> Observable<[String]> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        let bodyData = FirestoreQuery.nameFilter(by: text, selfNickname: nickname)
        let decodeTarget = [QueryResultValue<UserDataFirestoreDTO>].self
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ queryResult -> [String] in
                switch queryResult {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.compactMap({ $0.document?.toDomain().nickname })
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func save(mate nickname: String, to targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.commitKey
        let bodyData = FirestoreQuery.append(mate: nickname, to: targetNickname)
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    // MARK: - Notice Read/Update
    func fetchNotice(of userNickname: String) -> Observable<[Notice]> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.notificationPath + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath
        let decodeTarget = Documents<[NoticeDTO]>.self
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> [Notice] in
                switch result {
                case .success(let data):
                    guard let documents = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return documents.documents.map { $0.toDomain() }
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func save(notice: Notice, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.notificationPath + "/\(userNickname)"
        + FirestoreCollectionPath.recordsPath + "/\(Date().fullDateTimeNumberString())-\(notice.mode)-\(notice.sender)"
        
        let dto = NoticeDTO(from: notice)
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func updateState(notice: Notice, of userNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.firestoreBaseURL + (notice.id ?? "")
        let dto = NoticeDTO(from: notice)
        
        let bodyData = [FirestoreField.fields: dto]
        
        return self.urlSession.patch(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func remove(mate nickname: String, from targetNickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.commitKey
        
        let bodyData = FirestoreQuery.remove(mate: nickname, from: targetNickname)
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func fetchUserNickname(of uid: String) -> Observable<String> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.uidPath + "/\(uid)"
        
        return self.urlSession.get(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result -> String in
                switch result {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: FieldValue.self),
                          let nickname = dto.fields[FirestoreField.nickname]?.value else { throw Error.decodingError }
                    return nickname
                case .failure(let error):
                    throw error
                }
            })
    }
    
    func save(uid: String, nickname: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.uidPath + "/\(uid)"
        let bodyyData = FieldValue(value: [FirestoreField.nickname: StringValue(value: nickname)])
        
        return self.urlSession.patch(bodyyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    func fetchUID(of nickname: String) -> Observable<String?> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreConfiguration.queryKey
        let bodyData = FirestoreQuery.uidFilter(by: nickname)
        let decodeTarget = [QueryResultValue<Document>].self
        
        return self.urlSession.post(bodyData, url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map { queryResult -> String? in
                switch queryResult {
                case .success(let data):
                    guard let dto = self.decode(data: data, to: decodeTarget) else { throw Error.decodingError }
                    return dto.first?.document?.name?.components(separatedBy: "/").last
                case .failure(let error):
                    throw error
                }
            }
    }
    
    func removeUID(uid: String) -> Observable<Void> {
        let endPoint = FirestoreConfiguration.baseURL + FirestoreConfiguration.documentsPath
        + FirestoreCollectionPath.uidPath + "/\(uid)"
        
        return self.urlSession.delete(url: endPoint, headers: FirestoreConfiguration.defaultHeaders)
            .map({ result in
                switch result {
                case .success: break
                case .failure(let error): throw error
                }
            })
    }
    
    private func decode<T: Decodable>(data: Data, to target: T.Type) -> T? {
        return try? JSONDecoder().decode(target, from: data)
    }
}

extension DefaultFirestoreRepository {
    func save(profileImageData: Data, of userNickname: String) -> Observable<String> {
        let endPoint = FirebaseStorageConfiguration.baseURL
        + FirebaseStorageConfiguration.projectNamePath + "/\(userNickname)%2F"
        + FirebaseStorageConfiguration.profileImageName
        let header = FirebaseStorageConfiguration.mediaContentType
        let tokenKey = FirebaseStorageConfiguration.downloadTokens
        
        return self.urlSession.post(profileImageData, url: endPoint, headers: header)
            .map({ result -> String in
                switch result {
                case .success(let data):
                    guard let json = self.decode(data: data, to: [String: String].self),
                          let token = json[tokenKey] else { throw Error.decodingError }
                    return endPoint + "?"
                    + [FirebaseStorageConfiguration.altMediaParameter,
                       FirebaseStorageConfiguration.tokenParameter + token].joined(separator: "&")
                case .failure(let error):
                    throw error
                }
            })
    }
}
