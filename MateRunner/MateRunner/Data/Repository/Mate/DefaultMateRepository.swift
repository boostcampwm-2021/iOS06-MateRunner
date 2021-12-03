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
    let realtimeNetworkService: RealtimeDatabaseNetworkService
    let urlSessionNetworkService: URLSessionNetworkService
    
    init(
        realtimeNetworkService: RealtimeDatabaseNetworkService,
        urlSessionNetworkService: URLSessionNetworkService
    ) {
        self.realtimeNetworkService = realtimeNetworkService
        self.urlSessionNetworkService = urlSessionNetworkService
    }
    
    func sendRequestMate(from sender: String, fcmToken: String) -> Observable<Void> {
        let dto = MessagingRequestDTO(
            title: "🤝 메이트 요청",
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
        ).map({ _ in })
    }
    
    func sendEmoji(from sender: String, fcmToken: String) -> Observable<Void> {
        let dto = MessagingRequestDTO(
            title: "💝 이모지 도착",
            body: "\(sender)님이 칭찬 이모지를 보냈어요!",
            data: ComplimentEmoji(sender: sender),
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
        ).map({ _ in })
    }
    
    func fetchFCMToken(of mate: String)-> Observable<String> {
        return self.realtimeNetworkService.fetchFCMToken(of: mate)
    }
}
