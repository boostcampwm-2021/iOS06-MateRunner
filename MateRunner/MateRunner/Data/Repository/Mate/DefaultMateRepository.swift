//
//  DefaultMateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/16.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultMateRepository: MateRepository {
    let fireStoreNetworkService: FireStoreNetworkService
    let realtimeNetworkService: RealtimeDatabaseNetworkService
    let urlSessionNetworkService: URLSessionNetworkService
    
    init(
        fireStoreNetworkService: FireStoreNetworkService,
        realtimeNetworkService: RealtimeDatabaseNetworkService,
        urlSessionNetworkService: URLSessionNetworkService
    ) {
        self.fireStoreNetworkService = fireStoreNetworkService
        self.realtimeNetworkService = realtimeNetworkService
        self.urlSessionNetworkService = urlSessionNetworkService
    }
    
    func fetchMateNickname() -> Observable<[String]> {
        return self.fireStoreNetworkService.fetchData(
            type: [String].self,
            collection: FirebaseCollection.user,
            document: "yujin",
            field: "mate"
        )
    }
    
    func fetchMateProfileImage(from nickname: String) -> Observable<String> {
        return self.fireStoreNetworkService.fetchData(
            type: String.self,
            collection: FirebaseCollection.user,
            document: nickname,
            field: "image"
        )
    }
    
    func fetchFilteredNickname(text: String) -> Observable<[String]> {
        return self.fireStoreNetworkService.fetchFilteredDocument(
            collection: FirebaseCollection.user,
            with: text
        )
    }
    
    func sendRequestMate(from sender: String, fcmToken: String) -> Observable<Void> {
        let dto = MessagingRequestDTO(
            title: "메이트 요청",
            body: "메이트 요청이 도착했습니다!",
            data: MateRequest(sender: sender),
            to: fcmToken
        )
        
        return self.urlSessionNetworkService.post(
            dto,
            url: "https://fcm.googleapis.com/fcm/send",
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": Configuration.fcmServerKey
            ]
        )
    }
    
    func fetchFCMToken(of mate: String)-> Observable<String> {
        return self.realtimeNetworkService.fetchFCMToken(of: mate)
    }
    
    func saveRequestMate(_ notice: Notice?) -> Observable<Void> {
        guard let notice = notice else {
            return Observable.error(FirebaseServiceError.nilDataError)
        }
        
        return self.fireStoreNetworkService.writeDTO(
            NoticeDTO(from: notice),
            collection: "Notification",
            document: notice.receiver,
            key: notice.sender
        )
    }
}
